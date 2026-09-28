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

## Lab Activity 4: User Authentication and Profile Discussion

### Interaction Between User Model, Service, and Screen

The application extends the previous Model-Service-Screen architecture by adding user authentication and persistent user data. The User model represents the authenticated user's information such as the user ID, username, email, first name, last name, gender, profile image, access token, and refresh token.

The UserService is responsible for communicating with the DummyJSON authentication API and managing the user's saved information. The loginUser() method sends the username and password to the authentication endpoint. When the login is successful, the returned user information is converted into a User model and saved locally using SharedPreferences.

The saved user information can later be retrieved using getUserData() and getUser(). This allows the application to access the authenticated user's information without requesting the login API again every time a screen is opened.

The ProfileScreen uses UserService to retrieve the saved User model and displays the user's profile image, full name, username, email, gender, and user ID. This keeps the API and storage logic separated from the user interface.

### Persistent Authentication

The SplashScreen checks whether the user has a saved authentication token using the isLoggedIn() method of UserService. If a valid saved token exists, the user is automatically redirected to the HomeScreen. If there is no saved token, the user is redirected to the SignInScreen.

The SignInScreen uses UserService to authenticate the username and password. After a successful login, the returned user information and authentication tokens are saved in SharedPreferences. Because the data is stored locally, the application can remember the authenticated user even after the application is closed and opened again.

When the user logs out, UserService clears the saved SharedPreferences data and redirects the user back to the SignInScreen.

### Updated Design Pattern

The application continues to follow the Model-Service-Screen design pattern.

The Model layer contains Product, Cart, CartProduct, and User models. These models represent the different types of data used by the application.

The Service layer contains ProductService, CartService, and UserService. ProductService communicates with the Products API, CartService communicates with the Cart API, and UserService handles authentication and persistent user information.

The Screen layer contains the SplashScreen, SignInScreen, HomeScreen, ProductScreen, CartScreen, ProfileScreen, and SettingsScreen. Each screen focuses on displaying information and handling user interaction while the API and storage logic remain inside the service classes.

The Provider pattern continues to manage the application's theme through ThemeProvider, while SharedPreferences is used to persist authenticated user information.

### Rendering the Cart Using the Saved User ID

After a successful login, the authenticated user's ID is saved in SharedPreferences. The CartScreen retrieves the saved User model using UserService and obtains the current user's ID.

The saved user ID is then passed to the CartService getCartByUserId() method. The method sends a request to:

`/carts/user/{userId}`

This allows the CartScreen to display the cart that belongs to the currently authenticated user instead of using a hardcoded user ID.

The same saved user ID is also used when the ProductScreen sends a product to the Add Cart endpoint. This keeps cart operations associated with the authenticated user.

## Lab Activity 5: Firebase Authentication

### Discussion

Lab Activity 5 extends the previous authentication implementation by integrating Firebase Authentication while maintaining the existing DummyJSON authentication.

DummyJSON authentication uses an HTTP POST request to the `/auth/login` endpoint using a username and password. After a successful response, the returned user information and authentication token are saved locally. Firebase Authentication uses the FirebaseAuth SDK and authenticates users using an email address and password.

The application supports both authentication methods through UserService. DummyJSON users are authenticated using `loginUser()`, while Firebase users are authenticated using `signIn()`. New Firebase accounts are created using `createAccount()` through the Sign-Up screen, which collects the user's first name, last name, age, contact number, username, email address, and password.

UserService centralizes authentication and account-management operations so that the screens remain focused on the user interface. It handles DummyJSON login, Firebase authentication, account creation, logout, username updates, password changes, account deletion, session checking, and user-data retrieval.

A loginType value is used to identify whether the current user logged in through DummyJSON or Firebase. The Profile screen calls `UserService().getUserData()` and displays different information depending on the authentication method. Firebase users are also provided with account-management functions such as updating their username, changing their password, and deleting their account.

Firebase improves the application by providing built-in authentication, session management, account creation, reauthentication, password management, and account deletion through the FirebaseAuth SDK. This demonstrates the difference between traditional REST API authentication through DummyJSON and authentication through a dedicated backend authentication service.

## Lab Activity 6: Firebase Part II

### Discussion

Lab Activity 6 extends the previous Firebase Authentication implementation by integrating Cloud Firestore for real-time chat functionality.

Registered Firebase users are stored in the `Users` collection. Each user document uses the Firebase UID and contains user information such as first name, last name, username, email address, age, and contact number. The Chat List retrieves these records from Firestore using a real-time stream.

When a conversation is started, the Firebase UIDs of the two users are sorted and combined to create a unique chat room ID. Sorting the IDs ensures that both users access the same conversation regardless of who starts the chat. Messages are stored inside the `messages` subcollection of the corresponding document in the `chat_rooms` collection.

Each message stores the sender ID, sender email, receiver ID, message content, timestamp, and message status. The interface temporarily displays a Sending state while the message is being written to Firestore. After it is successfully stored, the message is treated as delivered. When the receiver opens the conversation, the message status is updated to seen.

The Chat List excludes the currently authenticated user by comparing each Firestore user UID with the UID of the logged-in Firebase user. This prevents users from starting a conversation with themselves. If self-chat were allowed, the same Firebase UID would be used as both sender and receiver, resulting in a chat room where the same account represents both sides of the conversation.

A search function was also implemented to allow users to filter registered accounts by name or email address. The Chat Detail screen was redesigned with separate sender and receiver bubbles, message states, and fade and slide animations to create a clearer and smoother messaging experience.