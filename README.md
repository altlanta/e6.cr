# e6.cr

A fast, simple, and easy-to-use e621/e926 client written in Crystal. 

(also my first Crystal project)

## Installation

1. Add the dependency to your `shard.yml`:

  ```yaml
  dependencies:
    e6:
      github: altlanta/e6.cr
  ```

2. Run `shards install`

## Usage

An example of getting a single post.

```crystal
require "e6"

e6c = Client.new
post = e6c.get_post(1011510)

if post
  puts post.rating # => "s"
  puts post.first_artist # => "huiro"
end
```

## Progress

At the moment, only the most basic functionality is implemented. The e6 API is very convoluted, so implementing more of these might take some time.

- [ ] [Create post](https://e621.net/help/api#posts_create)
- [ ] [Update post](https://e621.net/help/api#posts_update)
- [x] `Client#list_posts` [List posts](https://e621.net/help/api#posts_list)
- [x] `Client#get_post` Get single post
- [x] `Client#list_flags` [List flags](https://e621.net/help/api#flags_listing)
- [ ] [Create flag](https://e621.net/help/api#flags_creating)
- [ ] [Vote on post](https://e621.net/help/api#posts_vote)
- [ ] [List favorites](https://e621.net/help/api#favorites_listing)
- [ ] [Create favorites](https://e621.net/help/api#favorites_create)
- [ ] [Delete favorites](https://e621.net/help/api#favorites_delete)
- [x] `Client#list_tags` [List tags](https://e621.net/help/api#tags_listing)
- [ ] [List tag aliases](https://e621.net/help/api#tag_alias_listing)
- [ ] [List notes](https://e621.net/help/api#notes_listing)
- [ ] [Create notes](https://e621.net/help/api#notes_create)
- [ ] [Update notes](https://e621.net/help/api#notes_update)
- [ ] [Delete notes](https://e621.net/help/api#notes_delete)
- [ ] [Revert notes](https://e621.net/help/api#notes_revert)
- [ ] [List pools](https://e621.net/help/api#pools_listing)
- [ ] [Create pools](https://e621.net/help/api#pools_create)
- [ ] [Update pools](https://e621.net/help/api#pools_update)
- [ ] [Revert pools](https://e621.net/help/api#pools_revert)

Additionally, a CLI wrapper is in the works.

## Contributing

1. Fork it (<https://github.com/altlanta/cr-e6client/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [altlanta](https://github.com/altlanta) - creator and maintainer

## Notes

**To clarify the name,** "e6.cr" is the proper name of this lib. However, to prevent redundancy in file naming, the *technical* name is simply "e6". (since `.cr` is the common file extension)
