


from flask import Flask, render_template, request
import mysql.connector
from os import getenv

# todo: move this to another folder
def valid_password(password):
    return len(password) > 4


app = Flask(__name__)

db_connection = mysql.connector.connect(
  host = "localhost",
  user = "root",
  password = getenv("MySQLpassword"),
  database = "quoteslection"
)

db = db_connection.cursor()


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/signup", methods=["GET", "POST"])
def signup():
    # visiting signup page
    if request.method == "GET":
        return render_template("signup.html")

    # submitting signup form
    firstname = request.form.get("firstname")
    lastname = request.form.get("lastname")
    username = request.form.get("username")
    password = request.form.get("password")

    if not all((request.form.get("firstname"), request.form.get("lastname"), request.form.get("username"), request.form.get("password"))):
        return render_template("signup.html", error="Please fill all fields.")
    
    if not firstname.isalpha() or not lastname.isalpha():
        return render_template("signup.html", error="Please enter your name properly.")

    if " " in username:
        return render_template("signup.html", error="Username can't have spaces.")

    if not valid_password(password):
        return render_template("signup.html", error="Password can't be less than 4 characters.")

    # check if username in db here.....
    
    db.execute("""
    INSERT INTO users (username, firstname, lastname, pass) 
    VALUES (%s, %s, %s, %s);""",
    (username, firstname, lastname, password))

    db_connection.commit()

    return redirect("/")

app.run(debug=True)
