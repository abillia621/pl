InventoryTracker/
├── InventoryApp.java
├── InventoryManager.java
├── InventoryItem.java
├── FileHandler.java
├── ReportGenerator.java
└── inventory.txt

import java.io.Serializable;

public class InventoryItem implements Serializable {
    private String id;
    private String name;
    private int quantity;
    private double price;

    public InventoryItem(String id, String name, int quantity, double price) {
        this.id = id;
        this.name = name;
        this.quantity = quantity;
        this.price = price;
    }

    public String getId() { return id; }
    public String getName() { return name; }
    public int getQuantity() { return quantity; }
    public double getPrice() { return price; }

    public void setName(String name) { this.name = name; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public void setPrice(double price) { this.price = price; }

    @Override
    public String toString() {
        return "ID: " + id + " | Name: " + name + " | Qty: " + quantity + " | Price: $" + price;
    }
}

import java.io.*;
import java.util.*;

public class FileHandler {
    private static final String FILE_NAME = "inventory.txt";

    public static void saveItems(List<InventoryItem> items) {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(FILE_NAME))) {
            oos.writeObject(items);
        } catch (IOException e) {
            System.out.println("Error saving data: " + e.getMessage());
        }
    }

    public static List<InventoryItem> loadItems() {
        List<InventoryItem> items = new ArrayList<>();
        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(FILE_NAME))) {
            items = (List<InventoryItem>) ois.readObject();
        } catch (IOException | ClassNotFoundException e) {
            // Ignore, file may be empty on first launch
        }
        return items;
    }
}

import java.util.*;

public class InventoryManager {
    private List<InventoryItem> items;

    public InventoryManager() {
        items = FileHandler.loadItems();
    }

    public void addItem(String id, String name, int qty, double price) {
        if (findItemById(id) != null) {
            System.out.println("Item with this ID already exists!");
            return;
        }
        items.add(new InventoryItem(id, name, qty, price));
        System.out.println("Item added successfully!");
        FileHandler.saveItems(items);
    }

    public void viewItems() {
        if (items.isEmpty()) {
            System.out.println("Inventory is empty.");
            return;
        }
        for (InventoryItem item : items) {
            System.out.println(item);
        }
    }

    public void updateItem(String id, String name, int qty, double price) {
        InventoryItem item = findItemById(id);
        if (item == null) {
            System.out.println("Item not found!");
            return;
        }
        item.setName(name);
        item.setQuantity(qty);
        item.setPrice(price);
        System.out.println("Item updated.");
        FileHandler.saveItems(items);
    }

    public void deleteItem(String id) {
        InventoryItem item = findItemById(id);
        if (item != null) {
            items.remove(item);
            System.out.println("Item deleted.");
            FileHandler.saveItems(items);
        } else {
            System.out.println("Item not found.");
        }
    }

    private InventoryItem findItemById(String id) {
        return items.stream().filter(i -> i.getId().equals(id)).findFirst().orElse(null);
    }

    public void generateReport() {
        System.out.println("===== Inventory Report =====");
        System.out.println("Total Items: " + items.size());
        double totalValue = items.stream().mapToDouble(i -> i.getQuantity() * i.getPrice()).sum();
        System.out.println("Total Inventory Value: $" + totalValue);
    }
}

import java.util.Scanner;

public class InventoryApp {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        InventoryManager manager = new InventoryManager();

        while (true) {
            System.out.println("\n--- Inventory Menu ---");
            System.out.println("1. Add Item");
            System.out.println("2. View All Items");
            System.out.println("3. Update Item");
            System.out.println("4. Delete Item");
            System.out.println("5. Generate Report");
            System.out.println("0. Exit");
            System.out.print("Choose an option: ");

            String choice = scanner.nextLine();

            try {
                switch (choice) {
                    case "1":
                        System.out.print("Enter ID: ");
                        String id = scanner.nextLine().trim();
                        System.out.print("Enter Name: ");
                        String name = scanner.nextLine().trim();
                        System.out.print("Enter Quantity: ");
                        int qty = Integer.parseInt(scanner.nextLine().trim());
                        System.out.print("Enter Price: ");
                        double price = Double.parseDouble(scanner.nextLine().trim());

                        if (id.isEmpty() || name.isEmpty() || qty < 0 || price < 0) {
                            System.out.println("Invalid input.");
                            break;
                        }

                        manager.addItem(id, name, qty, price);
                        break;
                    case "2":
                        manager.viewItems();
                        break;
                    case "3":
                        System.out.print("Enter ID to update: ");
                        id = scanner.nextLine().trim();
                        System.out.print("New Name: ");
                        name = scanner.nextLine().trim();
                        System.out.print("New Quantity: ");
                        qty = Integer.parseInt(scanner.nextLine().trim());
                        System.out.print("New Price: ");
                        price = Double.parseDouble(scanner.nextLine().trim());
                        manager.updateItem(id, name, qty, price);
                        break;
                    case "4":
                        System.out.print("Enter ID to delete: ");
                        id = scanner.nextLine().trim();
                        manager.deleteItem(id);
                        break;
                    case "5":
                        manager.generateReport();
                        break;
                    case "0":
                        System.out.println("Exiting...");
                        return;
                    default:
                        System.out.println("Invalid choice. Try again.");
                }
            } catch (Exception e) {
                System.out.println("Error: " + e.getMessage());
            }
        }
    }
}



# Inventory Item Tracker

### Student: [Ваше Имя]

## 📌 Description
Это консольное приложение позволяет управлять складом: добавлять, просматривать, обновлять и удалять товары.

## 🎯 Objectives
- Реализация операций CRUD
- Хранение данных в файле
- Удобный интерфейс командной строки
- Генерация отчётов
- Валидация и обработка ошибок

## ✅ Features
- Создание/обновление/удаление товаров
- Просмотр всех товаров
- Отчёты: общее количество и стоимость товаров
- Хранение данных между сессиями
- Валидация данных

## 💾 Data Format
Сериализованный файл `inventory.txt`

## 📸 Screenshots
(Добавьте скриншоты работы программы)

## 🛠️ Requirements
- Java 8+
