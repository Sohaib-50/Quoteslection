from functools import wraps
from flask import request, redirect, url_for, session

def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get("user_id") is None:
            return redirect(url_for('signin', next=request.url))
        return f(*args, **kwargs)
    return decorated_function


def signin_user(user_id, username, firstname, lastname):
    session["user_id"] = user_id
    session["username"] = username
    session["firstname"] = firstname
    session["lastname"] = lastname


def signout_user():
    session.clear()


def valid_password(password):
    return len(password) > 4


def get_favourites(db, quotes):
    favourites = set()
    # fetch and store in a set all quote_ids for which the quote is favourite for the current user, if logged in
    if user_id := session.get("user_id"):
        # for every quote fetched earlier
        for quote in quotes:
            # if quote_id, user_id combination exists in the favourite table, then add the quote id to favourites set
            quote_id = quote["quote_id"]
            db.execute(f"""SELECT * FROM favourite WHERE quote_id = %s and user_id = %s;""",
                       (quote_id, user_id))
            if db.fetchone():
                favourites.add(quote_id)
    return favourites