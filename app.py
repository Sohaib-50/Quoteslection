


from flask import Flask, render_template, request, session
from flask_session import Session
import mysql.connector
from os import getenv

from werkzeug.utils import redirect

# todo: move this to another folder
def valid_password(password):
    return len(password) > 4


app = Flask(__name__)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

db_connection = mysql.connector.connect(
  host = "localhost",
  user = "root",
  password = getenv("MySQLpassword"),
  database = "quoteslection"
)

db = db_connection.cursor()


@app.route("/")
def index():
    return render_template("index.html", title="Home")


@app.route("/signup", methods=["GET", "POST"])
def signup():
    if session.get("user_id"):
        return redirect("/")
        
    # visiting signup page
    if request.method == "GET":
        return render_template("signup.html", title="Sign Up")

    # submitting signup form
    firstname = request.form.get("firstname")
    lastname = request.form.get("lastname")
    username = request.form.get("username")
    password = request.form.get("password")
    password2 = request.form.get("password2")

    if not all((request.form.get("firstname"), request.form.get("lastname"), request.form.get("username"), request.form.get("password"))):
        return render_template("signup.html", error="Please fill all fields.", title="Sign Up")
    
    if not firstname.isalpha() or not lastname.isalpha():
        return render_template("signup.html", error="Please enter your name properly.", title="Sign Up")

    if " " in username:
        return render_template("signup.html", error="Username can't have spaces.", title="Sign Up")

    if not valid_password(password):
        return render_template("signup.html", error="Password can't be less than 4 characters.", title="Sign Up")

    if password != password2:
        return render_template("signup.html", error="Passwords don't match.", title="Sign Up")

    # check if username in db here.....
    
    db.execute("""
    INSERT INTO users (username, firstname, lastname, pass) 
    VALUES (%s, %s, %s, %s);
    """,
    (username, firstname, lastname, password))

    db_connection.commit()

    return redirect("/")


@app.route("/signin", methods=["POST", "GET"])
def signin():
    if session.get("user_id"):
        return redirect("/")
            
    if request.method == "GET":
        return render_template("signin.html", title="Sign In")

    username = request.form.get('username')
    password = request.form.get('password')
    
    if not username or not password:
        return render_template("signin.html", error="Please enter your username and password", title="Sign In")

    db.execute(f"""
    SELECT * FROM users
    WHERE username = "{username}"
    and pass = "{password}";
    """)  # TODO: save from sqlinjection

    user_row = db.fetchone()
    if not user_row:
         return render_template("signin.html", error="Incorrect username and/or password", title="Sign In")
    
    # successfully passed all checks and logged in
    session["user_id"] = user_row[0]
    session["username"] = user_row[1]
    session["firstname"] = user_row[2]
    session["lastname"] = user_row[3]
    return redirect("/")
   

@app.route("/signout")
def signout():
    if session.get("user_id"):
        del session["user_id"]
        del session["username"]
        del session["firstname"]
        del session["lastname"]

    return redirect("/")

@app.route("/all")
def all_quotes():
    db.execute("""SELECT quote_text,quotee, firstname,lastname
    FROM quotes INNER JOIN users
    ON quotes.user_id = users.id;""")
    quotes = db.fetchall()  # TODO: change quotes variable name?
    return render_template("allquotes.html", quotes=quotes, title="All Quotes")


@app.route("/myquotes")
def my_quotes():
    if not session.get("user_id"):
        return redirect("/")

    db.execute(f"""SELECT quote_text, quotee, firstname, lastname
    FROM quotes INNER JOIN users
    ON quotes.user_id = users.id
    WHERE users.id = { session["user_id"] };""")
    quotes = db.fetchall()
    return render_template("myquotes.html", quotes=quotes, title="My Quotes")


@app.route("/submit", methods=["POST", "GET"])
def submit():
    if not session.get("user_id"):
        redirect("/")

    if request.method == "GET":
        return render_template("submit.html", title="Submit a quote")

    quote = request.form.get("quote")
    quotee = request.form.get("quotee")

    if not quote or not quotee:
        return render_template("submit.html", error="Please fill both fields", title="Submit a quote")
    
    db.execute("""
    INSERT INTO quotes (quote_text, quotee, user_id)
    VALUES (%s, %s, %s);
    """,
    (quote, quotee, session.get("user_id")))

    db_connection.commit()

    return render_template("submit.html", success="Successfully submitted", title="Submit a quote")

    








app.run(debug=True)
