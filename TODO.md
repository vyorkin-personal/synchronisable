Primary objectives
======================================
- [ ] fix a mess with Context: return an array of sync contexts,
      or aggregate all syncronization contexts into just one
- [ ] destroy_missed
- [ ] write a good README
- [ ] extended interface
  - [ ] handle case when association type is a :hash
  - [ ] sync method for collection proxy (Model.where(condition).sync)
- [ ] better specs for cases when we should fetch/find using complex params

Think about
======================================
- [ ] has_many :bars, :through => FooModel
- [ ] polymorphic associations


The desired interface:
======================================
```
+ Model.sync
+ Model.sync([{},...])
```

```
+ Match.sync(:include => {
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
