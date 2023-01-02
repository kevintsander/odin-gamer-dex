# Gamer-dex

Gamer-dex is a Facebook clone designed to link gamers together. This project was developed as the final project in the Ruby on Rails full stack curriculum from The Odin Project.

# Versions

This application was developed with Ruby 3.1.2 and Rails 7.0.4.

# Friendships

Modeling friendships as a bi-directional relationship was an interesting problem. In the relationship table, we must have two fields to store user ids and the user we are interested in could be in either field.

This could be achieved easily with duplicate records with both user ids swapping columns, or by querying multiple times, but I wanted to try to optimize and avoid the overhead.
The easiest method would be to double the records for each relationship with the user ids swapped, but I wanted to avoid this overhead, and implemented the method outlined in [this stackoverflow post](https://stackoverflow.com/questions/37244283/how-to-model-a-mutual-friendship-in-rails/61904089#61904089).

# Queries

I found during this project that when cramming a lot of different data (user relationships, posts, etc) into a SPA, it is easy to spawn a lot of queries. It is crucial to reduce N+1 queries.

I also had several places where I needed to check the existence of an object (does the `current_user` have friends?) before getting data from it (displaying the friend list). `user.friends.exists?` runs a lightweight query to check if the record exists, and a separate query must be run to retrieve the friends, thus generating 2 queries for any user who has friends (which is hopefully everyone!). To reduce this traffic, I switched from `user.friends.exists?` to `user.friends.present?` to load the full dataset before checking existence. Of course the query is less lightweight, but it saves us a roundtrip by caching the data for reuse elsewhere on the page.

I suspect that #exists? would be more useful if the underlying data either did not need to be displayed, or if it was to be loaded in a separate asynchronous request.

There are other opportunities for further optimizations by further breaking down sections and components into more Turbo Frames operating in parallel.

# Infinite Post Scroll

I am using Turbo Streams and pagination with the Pagy gem to load new post pages as the user scrolls down.

# Attachment Previews

The default HTML file picker does not show image previews, so I created a Stimulus controller which will add the image previews using Javascript.
When editing a post, Rails will replace the old attachments and add the new attachment (or none if no selection made); A better UX would allow the user to keep or selectively delete the existing attachments, but that was out of scope for this project.
