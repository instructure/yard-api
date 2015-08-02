# `@object`

This tag allows you to define and describe an API _data object_, which would be any structured output from an API endpoint. Usually, these objects are shared across several endpoints, like creating a quiz, updating it, and retrieving it would all require and yield the same data object.

## Syntax

We use JSON to describe the object, and there are two notations for doing this which are described below.

### Format A: Swagger-style (recommended)

This style requires you to describe several items in every property of the object, like what it is, what type of data it contains, and an example value.

Currently, the recognized property items by YARD-API are:

- `description` - a full description of the property
- `type` - the data the of the property, like `Boolean` or `String`
- `example` - an example value(s) the property may contain
- `accepted_values` - an array of possible values the property can contain
- `required` - a boolean indicating whether this property is required (in either input or output scenarios)

Technically, they are all optional, but obviously that's not very helpful. At least, you should define a `type` and a `description` for every property.

```json
  // The ID of the object has to be unique inside the controller's scope,
  // and across the entire app's scope if you want to use a shortcut link
  // to it (like {API::Object} instead of {API::Controller::Object}).
  "id": "Unique ID of the object",
  "description": "A brief, or long, description of this object.",
  "properties": {
    // ...
    // Property definitions go here. Refer to the examples for more.
  }
```

The examples below will show you how to utilize these items.

### Format B: POJO

This format is much easier but less powerful. We'll use POJOs (plain-old-JSON-objects) to list the object's properties, and regular JavaScript comments to describe them.

```json
{
  // You would write the description of prop1 here.
  "prop1": "an example value",
  // And prop2 here, etc.
  "prop2": true,
  "prop3": 5.25,
  // ...
  "propN": null
}
```

Note that it is not possible to write an object's description in this format.

## Examples

### Swagger style

```ruby
{
  "id": "Shirt",
  "description": "A real T-Shirt.",
  "properties": {
    "id": {
      "type": "String"
    },
    "color": {
      "description": "Color of the shirt.",
      "type": "String"
    },
    "size": {
      "type": "String",
      "description": "Size of the shirt.",
      "accepted_values": [ "S", "M", "L", "XL" ],
      "required": true
    }
  }
}
```

### POJO style

```json
{
  // The unique ID of this shirt. This is always a string.
  "id": "1",

  // The color of the shirt.
  "color": "red",

  // The size of the shirt.
  // 
  // This is a required property when POSTing, and is always present.
  // 
  // Accepted values: "S", "M", "L", and "XL"
  "size": "M"
}
```