# Gamer-dex

Gamer-dex is a Facebook clone designed to link gamers together. This project was developed as the final project in the Ruby on Rails full stack curriculum from The Odin Project.

# Versions

This application was developed with Ruby 3.1.2 and Rails 7.0.4.

# Friendships

Modeling friendships as a bi-directional relationship was an interesting problem. In the relationship table, we must have two fields to store user ids and the user we are interested in could be in either field.

This could be achieved easily with duplicate records with both user ids swapping columns, or by querying multiple times, but I wanted to try to optimize and avoid the overhead.
The easiest method would be to double the records for each relationship with the user ids swapped, but I wanted to avoid this overhead, and implemented the method outlined in [this stackoverflow post](https://stackoverflow.com/questions/37244283/how-to-model-a-mutual-friendship-in-rails/61904089#61904089).
