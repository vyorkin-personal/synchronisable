Primary objectives
======================================
- [x] general tests
- [x] except/only
- [x] sync method
- [x] dependent syncronization & mapping
- [x] tests for Synchronisable.sync
- [ ] fix a mess with Context: return an array of sync contexts,
      or aggregate all syncronization contexts into just one
- [ ] destroy_missed
- [x] worker.rb refactoring
- [x] integrate with travis, stillmaintained, gemnasium,
      codeclimate, coveralls, inch-pages, codersclan
- [ ] write a good README
- [ ] extended interface
  - [ ] sync with include
  - [x] sync with ids array
  - [ ] handle case when association type is a :hash
  - [ ] sync method for collection proxy (Model.where(condition).sync)

Think about
======================================
- [ ] has_many :bars, :through => FooModel
- [ ] polymorphic associations

Secondary objectives
======================================
- [x] option for verbose logging
- [x] colorized STDOUT
- [ ] actualize docs


The desired interface:
======================================
```
+ Model.sync
+ Model.sync([{},...])
```

```
Match.sync(:include => {
  :match_players => :player
})
+ Model.sync([id1, ..., idn])
```

```
Model.where(condition).sync
Match.where(condition).sync(:include => {
  :match_players => :player
})
```
