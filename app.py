from os import getenv

import mysql.connector
from flask import Flask, jsonify, render_template, request, session, url_for, flash
from werkzeug.utils import redirect
from werkzeug.security import check_password_hash, generate_password_hash


from flask_session import Session
from helpers import signin_user, signout_user, valid_password


app = Flask(__name__)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

db_connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password=getenv("MySQLpassword"),
    database="quoteslection"
)

db = db_connection.cursor(dictionary=True)


@app.route("/")
def index():
    return render_template("index.html", title="Home")


@app.route("/signup", methods=["GET", "POST"])
def signup():
    # if already logged in
    if session.get("user_id"):
        return redirect("/")

    # just visiting signup page
    if request.method == "GET":
        return render_template("signup.html", title="Sign Up")

    # submitting signup form
    firstname = request.form.get("firstname")
    lastname = request.form.get("lastname")
    username = request.form.get("username")
    password = request.form.get("password")
    confirm_password = request.form.get("confirm_password")

    if not all((firstname, username, password, confirm_password)):
        return render_template("signup.html", error="Please fill all the mandatory fields.", title="Sign Up")

    if not firstname.isalpha() or not lastname.isalpha():
        return render_template("signup.html", error="Please enter your name properly.", title="Sign Up")

    # check if username already exists
    db.execute("SELECT * FROM user WHERE username = %s;", (username, ))
    if db.fetchone():
        return render_template("signup.html", error="Sorry that username already exists", title="Sign Up")

    if " " in username:
        return render_template("signup.html", error="Username can't have white spaces.", title="Sign Up")

    if not valid_password(password):
        return render_template("signup.html", error="Password can't be less than 4 characters.", title="Sign Up")

    if password != confirm_password:
        return render_template("signup.html", error="Passwords don't match.", title="Sign Up")
    
    # add user to database
    db.execute("""
    INSERT INTO user (username, firstname, lastname, password_hash) 
    VALUES (%s, %s, %s, %s);""",
    (username, firstname, lastname, generate_password_hash(password)))
    db_connection.commit()
    
    db.execute("SELECT id FROM user WHERE username = %s", (username, ))
    signin_user(user_id=db.fetchone()["id"], username=username, firstname=firstname, lastname=lastname)
    
    flash(f"Successfully signed up. Welcome, {firstname}!")
    return redirect("/")


@app.route("/signin", methods=["POST", "GET"])
def signin():
    # if already logged in
    if session.get("user_id"):
        return redirect("/")

    # if just visiting the signin page
    if request.method == "GET":
        return render_template("signin.html", title="Sign In")
    
    # if submitted signin form

    username = request.form.get('username')
    password = request.form.get('password')

    if not username or not password:
        return render_template("signin.html", error="Please fill both fields", title="Sign In")

    # validate credentials
    db.execute(f"""
    SELECT * FROM user
    WHERE username = %s;""",
    (username, ))
    user_row = db.fetchone()
    if not user_row:
        return render_template("signin.html", error="Invalid username", title="Sign In") 
    if not check_password_hash(user_row["password_hash"], password):
        return render_template("signin.html", error="Invalid password", title="Sign In")

    # logging user in (if all checks above passed)
    signin_user(user_id=user_row["id"], username=user_row["username"], firstname=user_row["firstname"], lastname=user_row["lastname"])
    
    flash(f"Welcome, {user_row['firstname']}!", "success")
    if next_url := request.form.get("next"):
        return redirect(next_url)
    return redirect("/")


@app.route("/signout")
def signout():
    if session.get("user_id"):
        signout_user()

    return redirect("/")

@app.route("/all")
def all_quotes():
    db.execute("""SELECT quote_text, quotee, firstname, lastname, quote.id
    FROM quote INNER JOIN user
    ON quote.submitter_user_id = user.id
    ORDER BY submission ASC;""")
    quotes = db.fetchall()            # TODO: change quotes variable name?

    if session.get("user_id"):
        favourites = set()
        for quote in quotes:
            quote_id = quote[4]
            db.execute(f"""SELECT *
            FROM favourites
            WHERE quote_id = {quote_id} and user_id = {session.get("user_id")};""")
            if db.fetchone():
                favourites.add(quote_id)
        return render_template("allquotes.html", quotes=quotes, favourites=favourites, title="All Quotes")

    return render_template("allquotes.html", quotes=quotes, title="All Quotes")


@app.route("/myquotes")
def my_quotes():
    if not session.get("user_id"):
        return redirect("/")

    db.execute(f"""SELECT quote_text, quotee, firstname, lastname
    FROM quotes INNER JOIN user
    ON quotes.user_id = user.id
    WHERE user.id = { session["user_id"] };""")
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


@app.route("/favouriteify", methods=["POST"])
def favouriteify():
    print(request.form)
    quote_id = request.form.get("quote_id")
    if request.form.get("is_favourite") == 'true':
        db.execute(f"""DELETE FROM  favourites
        WHERE user_id = {session.get("user_id")} AND quote_id = {quote_id};""")
    else:
        db.execute("""
        INSERT INTO favourites (user_id, quote_id) 
        VALUES (%s, %s);
        """,
                   (session.get("user_id"), quote_id))
    db_connection.commit()
    return jsonify(True)


# @app.route("/make-favourite")
# def make_favourite():
#     user_id = session.get("user_id")
#     quote_id = request.arg.get("quote_idd")



if __name__ == "__main__":
    app.run(debug=True)
