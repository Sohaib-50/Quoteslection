from os import getenv

import mysql.connector
from flask import (Flask, flash, jsonify, render_template, request, session,
                   url_for)
from werkzeug.security import check_password_hash, generate_password_hash
from werkzeug.utils import redirect

from flask_session import Session
from helpers import (get_favourites, login_required, signin_user, signout_user,
                     valid_password)

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
    # check if sorting filter applied
    if request.args.get("sort_parameter") and request.args.get("sort_order"):
        sort_parameter = request.args.get("sort_parameter").lower()
        sort_order = request.args.get("sort_order").lower()
        if (sort_parameter not in ["quote_text", "quotee", "submitter", "fav_count"]) or (sort_order not in ["asc", "desc"]):
            flash("Something went wrong, please try doing whatever you were doing again.")
            return redirect("/")
    else:
        sort_parameter = "submission"
        sort_order = "DESC"

    db.execute(f"""SELECT quote.id AS quote_id, quote.quote_text, quote.quotee, CONCAT(user.firstname, " ", user.lastname) AS submitter, COUNT(favourite.quote_id) AS fav_count
    FROM user INNER JOIN quote ON user.id = quote.submitter_user_id LEFT OUTER JOIN favourite ON quote.id = favourite.quote_id
    GROUP BY quote.id
    ORDER BY {sort_parameter} {sort_order};""")
    quotes = db.fetchall()

    favourites = get_favourites(db, quotes)

    # return str(quotes)

    return render_template("index.html", quotes=quotes, favourites=favourites, title="Quoteslection")


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

    if not firstname.isalpha() or (lastname != "" and not lastname.isalpha()):
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
    signin_user(user_id=db.fetchone()[
                "id"], username=username, firstname=firstname, lastname=lastname)

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
    signin_user(user_id=user_row["id"], username=user_row["username"],
                firstname=user_row["firstname"], lastname=user_row["lastname"])

    flash(f"Welcome, {user_row['firstname']}!", "success")
    if next_url := request.form.get("next"):
        return redirect(next_url)
    return redirect("/")


@app.route("/signout")
def signout():
    if session.get("user_id"):
        signout_user()
        flash("Successfully signed out")

    return redirect("/")


@app.route("/my_favourites")
@login_required
def my_favourites():
    db.execute("""SELECT  CONCAT(user.firstname, " ", user.lastname) AS submitter, quote.id AS quote_id, quote_text, quotee, COUNT(favourite.quote_id) AS fav_count
        FROM  favourite INNER JOIN quote ON favourite.quote_id = quote.id INNER JOIN user ON quote.submitter_user_id = user.id
        WHERE favourite.quote_id IN (SELECT quote_id FROM favourite WHERE user_id = %s)	
        GROUP BY favourite.quote_id;""", (session.get("user_id"), ))
    fav_quotes = db.fetchall()

    return render_template("my_favourites.html", fav_quotes=fav_quotes, title="Quoteslection")


@app.route("/my_submissions")
@login_required
def my_submissions():
    db.execute("""SELECT quote.id AS quote_id, quote_text, quotee, COUNT(favourite.user_id) AS fav_count
    FROM user INNER JOIN quote ON user.id = quote.submitter_user_id LEFT OUTER JOIN favourite ON quote.id = favourite.quote_id
    WHERE quote.submitter_user_id = %s
    GROUP BY quote.id
    ORDER BY submission DESC;""",
               (session.get("user_id"), ))
    user_quotes = db.fetchall()

    favourites = get_favourites(db, user_quotes)
    return render_template("my_submissions.html", user_quotes=user_quotes, favourites=favourites, title="My Quotes")


@app.route("/submit", methods=["POST", "GET"])
@login_required
def submit():
    if request.method == "GET":
        return render_template("submit.html", title="Submit a quote")

    quote = request.form.get("quote")
    quotee = request.form.get("quotee")

    if not quote or not quotee:
        return render_template("submit.html", error="Please fill both fields", title="Submit a quote")

    # check if quote already exists
    db.execute("SELECT * FROM quote WHERE quote_text = %s", (quote, ))
    if db.fetchone():
        return render_template("submit.html", error="That quote already exists", title="Submit a quote")

    db.execute("""
    INSERT INTO quote (quote_text, quotee, submitter_user_id)
    VALUES (%s, %s, %s);
    """,
               (quote, quotee, session.get("user_id")))
    db_connection.commit()

    flash("Successfully submitted")
    return render_template("submit.html", title="Submit a quote")


# favourite quote API
@app.route("/favouriteify_quote", methods=["POST"])
def favouriteify_quote():
    quote_id = request.form.get("quote_id")
    if request.form.get("is_favourite") == 'true':
        db.execute(f"""DELETE FROM  favourite
        WHERE user_id = {session.get("user_id")} AND quote_id = {quote_id};""")
    else:
        db.execute("""
        INSERT INTO favourite (user_id, quote_id) 
        VALUES (%s, %s);
        """,
                   (session.get("user_id"), quote_id))
    db_connection.commit()

    db.execute(
        "SELECT COUNT(*) as fav_count FROM favourite WHERE quote_id = %s;", (quote_id, ))
    fav_count = db.fetchone()["fav_count"]
    return jsonify({"fav_count": fav_count})


@app.route("/delete_quote/<quote_id>", methods=["GET", "POST"])
@login_required
def delete_quote(quote_id):
    if request.method == "GET":
        db.execute("""SELECT id, quote_text, quotee FROM quote
        WHERE id = %s and submitter_user_id = %s""",
                   (quote_id, session.get("user_id")))
        db_result = db.fetchone()
        if not db_result:
            flash("The quote you tried to delete isn't yours.")
            return redirect("/my_submissions")
        return render_template("delete_quote.html", quote=db_result, title=f"Delete Quote")
    else:
        if request.form.get("confirm_delete") == "NO":  # user doesnt want to delete
            flash("Not deleted.")
            return redirect("/my_submissions")
        else:  # confirm delete
            db.execute(
                "DELETE FROM favourite WHERE quote_id = %s", (quote_id, ))

            db.execute("DELETE FROM quote WHERE id = %s", (quote_id, ))

            db_connection.commit()
            flash("successfully deleted.")
            return redirect("/my_submissions")


if __name__ == "__main__":
    app.run()
