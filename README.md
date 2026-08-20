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


## Lab Activity 3: Cart API and Updated Application Architecture Discussion

### Interaction Between Cart Model, Service, and Screen

The application extends the previous Model-Service-Screen architecture by adding a Cart feature. The Cart model represents the structure of the cart data received from the DummyJSON API. It contains information such as the cart ID, user ID, products, total amount, discounted total, total products, and total quantity. The CartProduct class represents each individual product inside the cart.

The CartService is responsible for communicating with the DummyJSON Cart API. It handles requests for retrieving all carts, retrieving a specific cart by ID, retrieving a cart using a user ID, and sending product information to the Add Cart endpoint.

The CartScreen uses CartService to retrieve and display cart information. It renders the products contained in the selected user's cart, including the product image, name, price, discount, and quantity controls.

Each product inside the CartScreen is clickable. When a cart product is selected, its product ID is passed to ProductService using the getProductById() method. The complete Product object is then passed to the existing ProductScreen. This allows both the HomeScreen and CartScreen to reuse the same product detail screen.

### Updated Design Pattern

The application continues to follow the Model-Service-Screen design pattern and separation of concerns.

The Model layer defines the structure of the data used by the application. Product represents product information, while Cart and CartProduct represent cart-related information.

The Service layer handles communication with external APIs. ProductService manages the Product API, while CartService manages the Cart API. Separating these services prevents API logic from being placed directly inside the user interface.

The Screen layer handles the presentation of data and user interaction. HomeScreen displays available products, ProductScreen displays complete product information, CartScreen displays the selected user's cart, and SettingsScreen handles the application's theme settings.

The application also continues to use reusable widgets and the Provider pattern from the previous activity. ThemeProvider remains responsible for managing the light and dark themes of the application.

### Cart by User ID

The DummyJSON Cart API allows carts to be retrieved using a user ID through the endpoint:

`/carts/user/{userId}`

In this activity, a specific user ID is passed to the getCartByUserId() method in CartService. The method sends an HTTP GET request to the Cart API and converts the returned JSON data into a Cart object.

Instead of displaying all available carts, CartScreen uses this method to render only one user's cart.

### Getting a Cart by ID

A specific cart can also be retrieved through the Cart endpoint:

`/carts/{cartId}`

The getCartById() method receives the cart ID and sends an HTTP GET request to the endpoint. If the request is successful, the JSON response is converted into a Cart object using Cart.fromJson().

This method is useful when the application needs to retrieve the information of one specific cart instead of requesting all carts.

### Add to Cart

The Add to Cart enhancement uses the endpoint:

`/carts/add`

The addToCart() method sends an HTTP POST request containing the user ID, selected product ID, and quantity.

The ProductScreen provides an Add to Cart button that passes the selected Product object's ID to CartService. After the request is processed successfully, the API returns the generated cart information.

DummyJSON simulates the Add Cart operation, meaning the new cart is returned by the API but is not permanently stored on the DummyJSON server.

