
#### Overview
Basicaly, hugo-theme-paramater is just a port, (still very uncomplete) of the [paralax-template][1] from [materializecss][2], where every text, link, image reference is replaced by template variables allowing customization whitout touching the layout. To deliver something, it needs a config.{toml,yaml,json} which define those variables. An extensive exemple is [there][3].

[1]: http://materializecss.com/templates/parallax-template/preview.html
[2]: http://materializecss.com
[3]: https://framagit.org/frv/demo-parallaxMaterializecss/raw/master/config.toml 

Some *subtile* modifications and clever additions were made to css :

NavBar extends to 100% page width putting the logo at the top left corner of page and links at the top right, for a demo just look ahead (a bit of scrolling might be required) :

```css
nav .container {
  width: 100%;
  padding-left: 10px;
}
```
{{< figure src="https://c2.staticflickr.com/8/7757/26309003244_bf4348f7f5_o.jpg" class="vignette" alt="liseron" >}}
Vignette class allow small pictures to be placed at the beginning of a paragraph cause I love it and use my wife's drawing for it. It's a cool replacement for «lettrines». And OK there is no reason to put it in a theme and it definetly would take place in /static/css of the site but it's my personnal way to make things I love. That said, if you don't like it, don't use it, the license allow you to use any part of the theme and leave the other unsused. Nobody, even myself, will prosecute you in any manner for doing so. So use it or not, I'll still leave it there. Well the paragraph wrapped, I can stop.

```css
figure.vignette {
  margin-left: 0;
}
figure.vignette img {
  margin-right: 10px;
  float: left;
  width: 90px;
}
```


```markdown
{{\% figure src="https://c2.staticflickr.com/8/7757/26309003244_bf4348f7f5_o.jpg" class="vignette" alt="liseron" \%"}}
```
Syntax highlighting is supported via highlight.js :

```html
<script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.6.0/highlight.min.js"></script>
```
```javascript
var s = "JavaScript syntax highlighting";
alert(s);
```

Support of github style TODO lists (don't know why materializecss hides checkboxes):

- [x] Homepage as original
- [x] Any text as variable
- [x] Any link as variable
- [x] Single view
- [ ] Nice single view
- [x] List view
- [ ] Nice list view
- [ ] Terms
- [ ] Clever taxonomies view

```markdown
- [x] Homepage as original
- [x] Any text as variable
- [x] Any link as variable
- [x] Single view
- [ ] Nice single view
- [x] List view
- [ ] Nice list view
- [ ] Terms
- [ ] Clever taxonomies view
```

rendered with custom.css :
```css
[type=checkbox].task-list-item {
  position: relative;
  opacity: initial;
  left: 0;
}
```
