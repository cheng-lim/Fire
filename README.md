# Fire Documentation

- Release: v0.0.2
- Published time: 10/22/2023

# Announcement

## What is Fire?

Fire is a open source query language that enables 10x faster and simpler NoSQL query writing.

Play around with the IDE, [Fire Thrower](https://firelang.org)!

[GitHub](https://github.com/cheng-lim/Fire)

## An introduction to Fire and Fire Thrower

Fire is a simple, easy-to-learn query language, explicitly designed for interacting with NoSQL databases, akin to the role SQL plays for relational databases. It facilitates seamless connections with various NoSQL databases, including Google Cloud Firestore, MongoDB, and AWS DynamoDB, using a unified syntax.

Fire’s syntax blends programming elements with SQL functions, ensuring that anyone familiar with languages like JavaScript, Python, Java, etc., can learn and use Fire with minimal hassle and without needing to constantly refer to online resources to find the right SQL syntax.

[Fire Thrower](https://firelang.org), the dedicated Integrated Development Environment (IDE) for Fire, enables users to execute Fire queries without the necessity of creating a distinct program solely for querying. Currently, Fire Thrower is in a closed beta phase and is restricted to a pre-designated database in Google Cloud Firestore that we have provided.

In essence, Fire and Fire Thrower are designed to make database interaction more accessible and intuitive, lowering the barriers and making it simpler to work with different databases. The goal is to provide a universal approach to querying languages, facilitating easier navigation through various NoSQL databases with a consistent and intuitive syntax.

# Table of content

# **Database Configuration**

## **Integrating Firebase Cloud Firestore with Fire Thrower**

### **Steps for Configuration:**

1. In Fire Thrower's top bar, click the settings button (represented by a gear icon), located adjacent to the documentation button (indicated by a help icon).
2. A side panel will emerge.
3. Activate the 'Use third-party Cloud Firestore' toggle.
4. Navigate to your Firebase Console, then select Project Settings > General > Your Apps > Web App > firebaseConfig, and copy your Firebase credentials.
5. Paste these credentials into Fire Thrower and hit the 'Save' button.

### **Secure Storage of Your Firebase Credentials**

Fire Thrower ensures the security of your Firebase credentials by storing and encrypting them directly in your browser. This local storage is exclusively for enabling Fire Thrower's connection to your Firestore database.

## **Exploring with a Sample Database Schema**

For testing purposes, we furnish a sample database schema. Find the structure below for reference.

```json
{
  "cities": {
    "london": {
      "country": "UK",
      "has_lakes": true,
      "neighboring_cities": ["Chelsea", "Oxford", "Cambridge"],
      "population": 123123123
    },
    "seattle": {
      "country": "USA",
      "has_lakes": true,
      "neighboring_cities": ["San Francisco", "Los Angeles", "Oakland"],
      "population": 1500000
    },
    "tokyo": {
      "country": "Japan",
      "has_lakes": false,
      "neighboring_cities": ["Osaka", "Nagoya", "Kyoto"],
      "population": 2000000
    }
  }
}
```

This example helps illustrate how your data is organized within the database, offering an intuitive starting point for your explorations.

# Get data

## Get all documents

`<collection>.get();`

Fire

```jsx
cities.get();
```

JavaScript

```jsx
import { collection, getDocs } from "firebase/firestore";

const querySnapshot = await getDocs(collection(db, "cities"));
querySnapshot.forEach((doc) => {
  console.log(doc.id, " => ", doc.data());
});
```

## Get multiple documents

`<collection>.<document>[].get();`

Fire

```jsx
cities.[tokyo, seattle].get();
```

JavaScript

```jsx
import { collection, documentId, getDocs, query, where } from "firebase/firestore";

const q = query(
  collection(db, "cities"),
  where(documentId(), "in", ["tokyo", "seattle"])
);

const querySnapshot = await getDocs(q);

querySnapshot.forEach((doc) => {
  console.log(doc.id, " => ", doc.data());
});
```

## Get a single document

`<collection>.<document>.get();`

Fire

```jsx
cities.tokyo.get();
```

JavaScript

```jsx
import { doc, getDoc } from "firebase/firestore";

const docRef = doc(db, "cities", "tokyo");
const docSnap = await getDoc(docRef);

if (docSnap.exists()) {
  console.log("Document data:", docSnap.data());
} else {
  console.log("No such document!");
}
```

## Get with a single condition

### Equal to

`<collection>.where(<field> == <value>).get();`

Fire

```jsx
cities.where(population == 1500000).get();
```

JavaScript

```jsx
import { collection, getDocs, query, where } from "firebase/firestore";

const q = query(
  collection(db, "cities"),
  where("population", "==", 1500000)
);

const querySnapshot = await getDocs(q);

querySnapshot.forEach((doc) => {
  console.log(doc.id, " => ", doc.data());
});
```

### Not equal to

`<collection>.where(<field> != <value>).get();`

Fire

```jsx
cities.where(population != 1500000).get();
```

JavaScript

```jsx
import { collection, getDocs, query, where } from "firebase/firestore";

const q = query(
  collection(db, "cities"),
  where("population", "!=", 1500000)
);

const querySnapshot = await getDocs(q);

querySnapshot.forEach((doc) => {
  console.log(doc.id, " => ", doc.data());
});
```

### Greater than

`<collection>.where(<field> > <value>).get();`

Fire

```jsx
cities.where(population > 1500000).get();
```

JavaScript

```jsx
import { collection, getDocs, query, where } from "firebase/firestore";

const q = query(
  collection(db, "cities"),
  where("population", ">", 1500000)
);

const querySnapshot = await getDocs(q);

querySnapshot.forEach((doc) => {
  console.log(doc.id, " => ", doc.data());
});
```

### Greater than or equal to

`<collection>.where(<field> >= <value>).get();`

Fire

```jsx
cities.where(population >= 1500000).get();
```

JavaScript

```jsx
import { collection, getDocs, query, where } from "firebase/firestore";

const q = query(
  collection(db, "cities"),
  where("population", ">=", 1500000)
);

const querySnapshot = await getDocs(q);

querySnapshot.forEach((doc) => {
  console.log(doc.id, " => ", doc.data());
});
```

### Less than

`<collection>.where(<field> < <value>).get();`

Fire

```jsx
cities.where(population < 1500000).get();
```

JavaScript

```jsx
import { collection, getDocs, query, where } from "firebase/firestore";

const q = query(
  collection(db, "cities"),
  where("population", "<", 1500000)
);

const querySnapshot = await getDocs(q);

querySnapshot.forEach((doc) => {
  console.log(doc.id, " => ", doc.data());
});
```

### Less than or equal to

`<collection>.where(<field> <= <value>).get();`

Fire

```jsx
cities.where(population <= 1500000).get();
```

JavaScript

```jsx
import { collection, getDocs, query, where } from "firebase/firestore";

const q = query(
  collection(db, "cities"),
  where("population", "<=", 1500000)
);

const querySnapshot = await getDocs(q);

querySnapshot.forEach((doc) => {
  console.log(doc.id, " => ", doc.data());
});
```

### Where in

`<collection>.where(<field> in <value>[]).get();`

Fire

```jsx
cities.where(country in ['UK', 'Japan']).get();
```

JavaScript

```jsx
import { collection, getDocs, query, where } from "firebase/firestore";

const q = query(
  collection(db, "cities"),
  where("country", "in", ["UK", "Japan"])
);

const querySnapshot = await getDocs(q);

querySnapshot.forEach((doc) => {
  console.log(doc.id, " => ", doc.data());
});
```

### Where not in

`<collection>.where(<field> out <value>[]).get();`

Fire

```jsx
cities.where(country out ['USA', 'Germany']).get();
```

JavaScript

```jsx
import { collection, getDocs, query, where } from "firebase/firestore";

const q = query(
  collection(db, "cities"),
  where("country", "not-in", ["USA", "Germany"])
);

const querySnapshot = await getDocs(q);

querySnapshot.forEach((doc) => {
  console.log(doc.id, " => ", doc.data());
});
```

### Array contains

`<collection>.where(<value> in <field>[]).get();`

Fire

```jsx
cities.where('English' in spoken_languages).get();
```

JavaScript

```jsx
import { collection, getDocs, query, where } from "firebase/firestore";

const q = query(
  collection(db, "cities"),
  where("spoken_languages", "array-contains", "English")
);

const querySnapshot = await getDocs(q);

querySnapshot.forEach((doc) => {
  console.log(doc.id, " => ", doc.data());
});
```

### Array contains any

`<collection>.where(<value>[] in <field>[]).get();`

Fire

```jsx
cities.where(['English','German'] in spoken_languages).get();
```

JavaScript

```jsx
import { collection, getDocs, query, where } from "firebase/firestore";

const q = query(
  collection(db, "cities"),
  where("spoken_languages", "array-contains-any", ["English", "German"])
);

const querySnapshot = await getDocs(q);

querySnapshot.forEach((doc) => {
  console.log(doc.id, " => ", doc.data());
});
```

# Predefined methods

## Rename a document

`<collection>.<document>.rename(<value>);`

Fire

```jsx
cities.tokyo.rename('osaka');
```

JavaScript

```jsx
import { doc, getDoc, setDoc, deleteDoc } from "firebase/firestore";

const docRef = doc(db, "cities", "tokyo");
const docSnap = await getDoc(docRef);

if (docSnap.exists()) {
	const docData = docSnap.data();
	const newDocRef = doc(db, "cities", "osaka");
	await newDocRef.setDoc(docData);
	await deleteDoc(docRef);
} else {
	console.log("Document not found");
}
```

## Rename a field

`<collection>.<document>.<field>.rename(<value>);`

Fire

```jsx
cities.tokyo.country.rename('nation');
```

JavaScript

```jsx
import { doc, getDoc, deleteField, updateDoc } from "firebase/firestore";

const docRef = doc(db, "cities", "tokyo");
const docSnap = await getDoc(docRef);

if (docSnap.exists()) {
	const docData = docSnap.data();
	if(!docData.has("country")) {
		console.log("Field not found");
	} else {
		const fieldValue = docData["country"];
		await updateDoc(docRef, {
			country: deleteField(),
			nation: fieldValue
		}
	}
} else {
	console.log("Document not found");
}
```

# Output format

The output will be presented in Fire’s pair (key-value) format, a JSON-like format. 
We have introduced the '->' symbol to provide a clear distinction between the ID and the data. Also, to enhance readability, we have also eliminated curly brackets '{ }' at the top level, using square brackets as the primary notation for pairs and lists.

Output in Fire

```jsx
london -> [
  neighbor_cities -> ['chelsea', 'oxford', 'cambridge'],
  population -> 123123123,
  country -> 'uk',
  has_lakes -> true
],
seattle -> [
  population -> 1500000,
  has_lakes -> true,
  neighbor_cities -> ['san francisco', 'los angeles', 'oakland'],
  country -> 'usa'
],
tokyo -> [
  neighbor_cities -> ['osaka', 'nagoya', 'kyoto'],
  population -> 2000000,
  country -> 'japan',
  has_lakes -> false,
  birth_rate -> 0.89
]
```

JSON Output in JSON

```json
"london": {
  "neighbor_cities": ["chelsea", "oxford", "cambridge"],
  "population": 123123123,
  "country": "uk",
  "has_lakes": true
},
"seattle": {
  "population": 1500000,
  "has_lakes": true,
  "neighbor_cities": ["san francisco", "los angeles", "oakland"],
  "country": "usa"
},
"tokyo": {
  "neighbor_cities": ["osaka", "nagoya", "kyoto"],
  "population": 2000000,
  "country": "japan",
  "has_lakes": false,
  "birth_rate": 0.89
}
```

# Errors

## Success

- WithValues
    - code: Z001
    - message: No message, but it means the process succeeded with values.
- WithoutValues
    - code: Z002
    - message: No message, but it means the process succeeded without values.
- DocumentRenamed
    - code: Z003
    - message: Success: Document $docId in collection $collectId has been successfully renamed to $newName.
- FieldRenamed
    - code: Z004
    - message: Success: Field $fieldId in $docId, collection $collectId has been successfully renamed to $newName.

## Get errors

- CollectionInvalidError
    - code: G001
    - message: CollectionInvalidError: Collection id is not found or invalid.
- DocumentInvalidError
    - code: G002
    - message: DocumentInvalidError: Document id is not found or invalid.
- InvalidConditionOperatorError
    - code: G003
    - message: InvalidConditionOperatorError: Condition does not contain any of `>=`, `<=`, `>`, `<`, `==`, `in`, `out`.
- UnsupportedConditionFormatError
    - code: G004
    - message: UnsupportedConditionFormatError: Condition contains unsupported formats.
- ImcompleteConditionError
    - code: G005
    - message: ImcompleteConditionError: Either field, operator, or value is missing.
- ValueNullError
    - code: G006
    - message: ValueNullError: Value cannot be null.
- NullInFieldArrayError
    - code: G007
    - message: NullInFieldArrayError: Elements in field array cannot be null.
- NullInValueArrayError
    - code: G008
    - message: NullInValueArrayError: Elements in value array cannot be null.
- DocumentNotFoundError
    - code: G009
    - message: DocumentNotFoundError: The document does not exist.
- FieldNotFoundError
    - code: G010
    - message: FieldNotFoundError: The field does not exist.

## Runtime errors

- InvalidInputError
    - code: R001
    - message: InvalidInputError: The input does not match any parsers in Fire Interpreter. Please check your syntax if whether it is correct.
- UnknownTypeError
    - code: R002
    - message: UnknownTypeError: The variable type is unknown.
- FirebaseError
    - code: R003
    - message:
    
    ```dart
    const title = 'FirebaseError:';
    errorMessage == null
              ? '$title No error messages available'
              : '$title $errorMessage';
    ```
    
- RuntimeError
    - code: R004
    - message:
    
    ```dart
    const title = 'RuntimeError:';
    errorMessage == null
              ? '$title No error messages available'
              : '$title $errorMessage';
    ```
    

## Predefined method errors

- RenameValueInvalidError
    - code: P001
    - message: RenameValueInvalidError: Rename value is invalid.
- FieldAlreadyExistsError
    - code: P002
    - message: FieldAlreadyExistsError: The field already exists.
- DocumentAlreadyExistsError
    - code: P003
    - message: DocumentAlreadyExistsError: The document already exists.

[Release: v0.0.2](https://www.notion.so/Release-v0-0-2-b558ea60c62949ce9a5ed4232d4dace4?pvs=21)

[Release: v0.0.1](https://www.notion.so/Release-v0-0-1-6cadd78c28034473b2245818addbfe96?pvs=21)