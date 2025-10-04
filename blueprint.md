
# Blueprint: Flutter Budgeting & Expense Tracking App

## Overview

This document outlines the plan and progress for building a comprehensive budgeting and expense tracking application using Flutter and Firebase. The app will provide users with tools to manage their finances, track spending, set budget goals, and gain insights into their financial habits.

## Features implemented

* **User Authentication & Profile Management:**
  - [ ] User signup with email and password (Firebase Auth).
  - [ ] User login and logout.
  - [ ] User profile screen to update details (name, email, password).
* **Dashboard:**
  - [ ] Display total spending for the current month.
  - [ ] Show remaining budget.
  - [ ] Visualize expenses by category using a pie chart (`fl_chart`).
  - [ ] List top spending categories.
* **Budget Goals:**
  - [ ] Screen to set a monthly budget.
  - [ ] Display budget progress on the dashboard.
* **Expense Tracking:**
  - [ ] Add new expenses with date, amount, description, and category.
  - [ ] Edit and delete existing expenses.
  - [ ] Support for recurring expenses.
* **Spending Categories:**
  - [ ] Predefined categories (Food, Transport, etc.).
  - [ ] Allow users to add/edit custom categories with color-coding.
* **Expense History:**
  - [ ] View a list of all transactions.
  - [ ] Filter expenses by date range and category.
  - [ ] Search functionality.
* **Data Storage:**
  - [ ] Use Cloud Firestore to store user data, expenses, budgets, and categories.
  - [ ] Data is synced across devices.
* **UI/UX & Design:**
  - [ ] Clean, modern, and responsive design using Material 3.
  - [ ] Support for both light and dark themes.
  - [ ] Custom fonts with `google_fonts`.
  - [ ] Intuitive navigation with `go_router`.

## Current Plan

1.  **Project Setup:**
    *   Add necessary dependencies (`firebase_core`, `firebase_auth`, `cloud_firestore`, `provider`, `go_router`, `fl_chart`, `intl`, `google_fonts`, etc.).
    *   Configure Firebase for the Flutter project.
    *   Set up the basic project structure and routing.
2.  **Authentication:**
    *   Build the login, signup, and profile screens.
    *   Implement the authentication logic using Firebase Auth.
3.  **Core Models & Services:**
    *   Define data models for User, Expense, Category, and Budget.
    *   Create a `FirestoreService` to manage database interactions.
4.  **Dashboard Implementation:**
    *   Design and build the main dashboard UI.
    *   Integrate charts and data displays.
5.  **Expense & Category Management:**
    *   Develop screens for adding, editing, and viewing expenses and categories.
6.  **Budgeting Feature:**
    *   Implement the budget setting and tracking functionality.
7.  **History & Filtering:**
    *   Build the expense history screen with search and filter capabilities.
8.  **Refinement & Testing:**
    *   Polish the UI, fix bugs, and ensure the app is stable.
