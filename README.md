# Princess Glyza D. Bermudez
## INF231
## CTADMOBL Advance Mobile Programming

A Flutter project that focuses on advance topics. Covering the Mobile to Web Transactions

## Lab Activity Instance

## Lab Activity 2: Application Architecture Discussion


### Interaction Between Model, Service, and Screen


The application follows a structured Flutter architecture where the model, service, and screen layers work together to retrieve, process, and display product data.


### Model Layer

The Model layer contains the Product class which represents the structure of product data used throughout the application. It defines the properties of each product such as title, description, price, category, brand, stock, rating, and other product specifications.

The model also handles JSON conversion through the `fromJson()` method, allowing API responses to be converted into usable Dart objects.


### Service Layer

The Service layer is responsible for communicating with the external API. The ProductService class handles HTTP requests, retrieves product data from the API, and converts the received JSON response into a list of Product objects using the Product model.

This separates API communication from the user interface, making the application easier to maintain and modify.


### Screen Layer

The Screen layer is responsible for displaying the data to the user. The HomeScreen requests product data from ProductService and presents the products using reusable ProductCard widgets.

When a user selects a product, the application navigates to the ProductScreen, which displays detailed information including category, brand, stock availability, rating, and specifications.

The SettingsScreen manages the application theme switching functionality using the ThemeProvider.


### New Design Pattern Used


The application follows a separation of concerns approach similar to the Model-View pattern.

The Model handles the data structure, the Service manages external data retrieval, and the Screens manage user interaction and presentation.


A reusable Widget component was also introduced through the ProductCard class. Instead of placing all UI code inside the HomeScreen, the product card design was separated into its own widget. This improves code organization, readability, and reusability.


The Provider pattern was also used for theme management. The ThemeProvider stores the current theme state and notifies the application whenever the user switches between light and dark mode.


Overall, this structure improves maintainability by separating data handling, business logic, and user interface components.