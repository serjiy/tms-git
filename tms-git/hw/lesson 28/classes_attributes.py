import math

# 1. Класс "Круг"
class Circle:
    def __init__(self, radius, color):
        self.radius = radius
        self.color = color
    
    def area(self):
        return math.pi * self.radius ** 2
    
    def circumference(self):
        return 2 * math.pi * self.radius
    
    def display_info(self):
        return f"Круг: радиус={self.radius}, цвет='{self.color}'"

# 2. Класс "Банковский счет"
class BankAccount:
    def __init__(self, account_number, owner_name, balance=0):
        self.account_number = account_number
        self.owner_name = owner_name
        self.balance = balance
    
    def deposit(self, amount):
        if amount > 0:
            self.balance += amount
            return f"Пополнено: {amount}. Новый баланс: {self.balance}"
        return "Сумма пополнения должна быть положительной"
    
    def withdraw(self, amount):
        if amount > 0:
            if amount <= self.balance:
                self.balance -= amount
                return f"Снято: {amount}. Новый баланс: {self.balance}"
            return "Недостаточно средств на счете"
        return "Сумма снятия должна быть положительной"
    
    def display_info(self):
        return f"Счет: {self.account_number}, Владелец: {self.owner_name}, Баланс: {self.balance}"

# 3. Класс "Студент"
class Student:
    def __init__(self, name, age, grades):
        self.name = name
        self.age = age
        self.grades = grades  # список оценок
    
    def calculate_average(self):
        if len(self.grades) == 0:
            return 0
        return sum(self.grades) / len(self.grades)
    
    def get_status(self):
        avg = self.calculate_average()
        if avg >= 4.5:
            return "отличник"
        elif avg >= 3.5:
            return "хорошист"
        else:
            return "троечник"
    
    def display_info(self):
        avg = self.calculate_average()
        status = self.get_status()
        return f"Студент: {self.name}, возраст: {self.age}, средний балл: {avg:.2f}, статус: {status}"

# 4. Класс "Книга"
class Book:
    def __init__(self, title, author, year):
        self.title = title
        self.author = author
        self.year = year
    
    def get_title(self):
        return self.title
    
    def get_author(self):
        return self.author
    
    def get_year(self):
        return self.year
    
    def set_title(self, new_title):
        self.title = new_title
    
    def set_author(self, new_author):
        self.author = new_author
    
    def set_year(self, new_year):
        self.year = new_year
    
    def display_info(self):
        return f"Книга: '{self.title}', автор: {self.author}, год: {self.year}"

# 5. Класс "Автомобиль"
class Car:
    def __init__(self, brand, model, color, year):
        self.brand = brand
        self.model = model
        self.color = color
        self.year = year
    
    def get_brand(self):
        return self.brand
    
    def get_model(self):
        return self.model
    
    def get_color(self):
        return self.color
    
    def get_year(self):
        return self.year
    
    def set_brand(self, new_brand):
        self.brand = new_brand
    
    def set_model(self, new_model):
        self.model = new_model
    
    def set_color(self, new_color):
        self.color = new_color
    
    def set_year(self, new_year):
        self.year = new_year
    
    def display_info(self):
        return f"Автомобиль: {self.brand} {self.model}, цвет: {self.color}, год: {self.year}"

# Демонстрация работы всех классов
def main():
    print("=" * 50)
    print("1. ДЕМОНСТРАЦИЯ КЛАССА 'КРУГ'")
    print("=" * 50)
    
    circle1 = Circle(5, "красный")
    circle2 = Circle(3.5, "синий")
    
    print(circle1.display_info())
    print(f"Площадь: {circle1.area():.2f}")
    print(f"Длина окружности: {circle1.circumference():.2f}")
    
    print()
    print(circle2.display_info())
    print(f"Площадь: {circle2.area():.2f}")
    print(f"Длина окружности: {circle2.circumference():.2f}")
    
    print("\n" + "=" * 50)
    print("2. ДЕМОНСТРАЦИЯ КЛАССА 'БАНКОВСКИЙ СЧЕТ'")
    print("=" * 50)
    
    account1 = BankAccount("1234567890", "Иванов Иван", 1000)
    account2 = BankAccount("0987654321", "Петров Петр", 500)
    
    print(account1.display_info())
    print(account1.deposit(500))
    print(account1.withdraw(200))
    print(account1.withdraw(2000))  # попытка снять больше, чем есть
    
    print()
    print(account2.display_info())
    print(account2.deposit(1000))
    print(account2.withdraw(300))
    
    print("\n" + "=" * 50)
    print("3. ДЕМОНСТРАЦИЯ КЛАССА 'СТУДЕНТ'")
    print("=" * 50)
    
    student1 = Student("Анна", 20, [5, 5, 4, 5, 5])
    student2 = Student("Борис", 21, [4, 3, 4, 4, 5])
    student3 = Student("Виктор", 22, [3, 3, 4, 3, 3])
    
    print(student1.display_info())
    print(student2.display_info())
    print(student3.display_info())
    
    print("\n" + "=" * 50)
    print("4. ДЕМОНСТРАЦИЯ КЛАССА 'КНИГА'")
    print("=" * 50)
    
    book1 = Book("Преступление и наказание", "Ф.М. Достоевский", 1866)
    book2 = Book("Мастер и Маргарита", "М.А. Булгаков", 1967)
    
    print(book1.display_info())
    print(book2.display_info())
    
    # Изменение атрибутов через методы
    book1.set_year(1867)
    print(f"\nПосле изменения года книги 1:")
    print(book1.display_info())
    
    book2.set_title("Мастер и Маргарита (полная версия)")
    print(f"\nПосле изменения названия книги 2:")
    print(book2.display_info())
    
    print("\n" + "=" * 50)
    print("5. ДЕМОНСТРАЦИЯ КЛАССА 'АВТОМОБИЛЬ'")
    print("=" * 50)
    
    car1 = Car("Toyota", "Camry", "черный", 2020)
    car2 = Car("BMW", "X5", "белый", 2022)
    
    print(car1.display_info())
    print(car2.display_info())
    
    # Изменение атрибутов через методы
    car1.set_color("синий")
    print(f"\nПосле изменения цвета автомобиля 1:")
    print(car1.display_info())
    
    car2.set_year(2023)
    print(f"\nПосле изменения года автомобиля 2:")
    print(car2.display_info())

if __name__ == "__main__":
    main()