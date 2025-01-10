import json
import os
import random
import string

USER_FILE = "Users_Details.json"
TRANSACTION_FILE = "Transactions_Details.json"

if not os.path.exists(USER_FILE):
    with open(USER_FILE, 'w') as f:
        json.dump({}, f)

if not os.path.exists(TRANSACTION_FILE):
    with open(TRANSACTION_FILE, 'w') as f:
        json.dump({}, f)

def load_data(file_path):
    with open(file_path, 'r') as f:
        return json.load(f)

def save_data(file_path, data):
    with open(file_path, 'w') as f:
        json.dump(data, f, indent=4)

def generate_random_password(length=8):
    """Generate a random password."""
    characters = string.ascii_letters + string.digits + string.punctuation
    return ''.join(random.choice(characters) for _ in range(length))

def create_account():
    """Create a user account."""
    users = load_data(USER_FILE)
    username = input("Enter a username: ").strip()
    if username in users:
        print("Username already exists. Please choose another.")
        return

    print("Do you want to generate a random password?")
    print("1. Yes")
    print("2. No")
    choice = input("Choose an option: ").strip()
    if choice == '1':
        password = generate_random_password()
        print(f"Your generated password is: {password}")
    elif choice == '2':
        password = input("Enter a password: ").strip()
    else:
        print("Invalid choice. Defaulting to manual password entry.")
        password = input("Enter a password: ").strip()

    users[username] = {
        "password": password,
        "balance": 0.0
    }
    save_data(USER_FILE, users)
    print("Account created successfully!")

def login():
    """User login."""
    users = load_data(USER_FILE)
    username = input("Enter your username: ").strip()
    if username not in users:
        print("Username not found.")
        return None

    password = input("Enter your password: ").strip()
    if users[username]["password"] == password:
        print("Login successful!")
        return username
    else:
        print("Incorrect password.")
        return None

def change_password(username):
    """Change user password."""
    users = load_data(USER_FILE)
    current_password = input("Enter your current password: ").strip()
    if users[username]["password"] != current_password:
        print("Incorrect current password.")
        return

    print("Do you want to generate a new random password?")
    print("1. Yes")
    print("2. No")
    choice = input("Choose an option: ").strip()
    if choice == '1':
        new_password = generate_random_password()
        print(f"Your new generated password is: {new_password}")
    elif choice == '2':
        new_password = input("Enter a new password: ").strip()
    else:
        print("Invalid choice. Password change aborted.")
        return

    users[username]["password"] = new_password
    save_data(USER_FILE, users)
    print("Password changed successfully!")

def deposit(username):
    """Deposit money."""
    users = load_data(USER_FILE)
    amount = float(input("Enter amount to deposit: "))
    if amount <= 0:
        print("Amount must be positive.")
        return

    users[username]["balance"] += amount
    save_data(USER_FILE, users)
    log_transaction(username, "Deposit", amount)
    print(f"Deposited {amount}. New balance: {users[username]['balance']}")

def withdraw(username):
    """Withdraw money."""
    users = load_data(USER_FILE)
    amount = float(input("Enter amount to withdraw: "))
    if amount <= 0:
        print("Amount must be positive.")
        return

    if users[username]["balance"] < amount:
        print("Insufficient balance.")
        return

    users[username]["balance"] -= amount
    save_data(USER_FILE, users)
    log_transaction(username, "Withdraw", amount)
    print(f"Withdrew {amount}. New balance: {users[username]['balance']}")

def check_balance(username):
    """Check user balance."""
    users = load_data(USER_FILE)
    print(f"Your balance is: {users[username]['balance']}")

def log_transaction(username, transaction_type, amount):
    """Log a transaction."""
    transactions = load_data(TRANSACTION_FILE)
    if username not in transactions:
        transactions[username] = []

    transactions[username].append({
        "type": transaction_type,
        "amount": amount
    })
    save_data(TRANSACTION_FILE, transactions)

def view_transactions(username):
    """View transaction history."""
    transactions = load_data(TRANSACTION_FILE)
    if username not in transactions or not transactions[username]:
        print("No transactions found.")
        return

    for i, txn in enumerate(transactions[username], start=1):
        print(f"{i}. {txn['type']}: {txn['amount']}")

def main():
    """Main menu of the program."""
    while True:
        print("\n--- Banking System ---")
        print("1. Create Account")
        print("2. Login")
        print("3. Exit")
        choice = input("Choose an option: ").strip()

        if choice == '1':
            create_account()
        elif choice == '2':
            username = login()
            if username:
                while True:
                    print("\n--- Account Menu ---")
                    print("1. Deposit")
                    print("2. Withdraw")
                    print("3. Check Balance")
                    print("4. View Transactions")
                    print("5. Change Password")
                    print("6. Logout")
                    sub_choice = input("Choose an option: ").strip()

                    if sub_choice == '1':
                        deposit(username)
                    elif sub_choice == '2':
                        withdraw(username)
                    elif sub_choice == '3':
                        check_balance(username)
                    elif sub_choice == '4':
                        view_transactions(username)
                    elif sub_choice == '5':
                        change_password(username)
                    elif sub_choice == '6':
                        print("Logged out.")
                        break
                    else:
                        print("Invalid option.")
        elif choice == '3':
            print("Exiting")
            break
        else:
            print("Invalid option.")

if __name__ == "__main__":
    main()
