# Refactoring Overview

This refactoring introduces a new object-oriented design to the `GildedRose` codebase, improving maintainability, readability, and extensibility. The main changes are:

- **Strategy Pattern for Item Updates:**  
  Introduced specialized classes (`BaseItem`, `AgedItem`, `LegendaryItem`, `AdmissionItem`) to encapsulate update logic for different item types, replacing the previous conditional-heavy approach.

- **ItemTransformer Module:**  
  Added an `ItemTransformer` module to map each `Item` to its corresponding strategy class, including support for "Conjured" items.

- **Error Handling:**  
  Added custom exceptions for invalid input and item types, as well as for invalid legendary item quality.

- **Single Responsibility Principle:**  
  Each class now has a clear responsibility, making the code easier to test and extend.

- **No Changes to Item Class:**  
  The original `Item` class remains unmodified as required.


# Gilded Rose starting position in Ruby

## Installation

## Run the unit tests from the Command-Line

Ensure you have RSpec installed

    gem install rspec

```
rspec gilded_rose_spec.rb
```

## Run the TextTest fixture from the Command-Line

For e.g. 10 days:

```
ruby texttest_fixture.rb 10
```

You should make sure the command shown above works when you execute it in a terminal before trying to use TextTest (see below).

## Run the TextTest approval test that comes with this project

There are instructions in the [TextTest Readme](../texttests/README.md) for setting up TextTest. You will need to specify the Ruby executable and interpreter in [config.gr](../texttests/config.gr). Uncomment these lines:

    executable:${TEXTTEST_HOME}/ruby/texttest_fixture.rb
    interpreter:ruby
