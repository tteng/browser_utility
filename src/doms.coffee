###
//@author: tim.teng <shreadline@gmail.com>
//@desc:   utilities for building html doms
###

class Html

  createForm: (attrs) ->
    $("<form/>", attrs)

  createLabel: (labelName) ->
    $("<label><strong>#{labelName}</strong>:</label>")

  createParagraph: ->
    $("<p align='right'/>")

  createTextField: (inputName, attrs) ->
    inputType = if typeof(attrs) != 'undefined' then attrs["inputType"] else "text" 
    if inputType == "textarea"
      dom = $("<textarea/>",
              {
                name: inputName,
                cols: 60,
                rows: 8,
                placeholder: attrs["placeholder"]
              }
             )
    else
      dom = $("<input/>",
              css: { "line-height": '30px' },
              name: inputName
            )
      ### specify size not work in above attribute, dont konw why ###
      dom.attr "size", 55
    dom

  createInputParagraph: (labelName, inputName, attrs) ->
    paragraph = @createParagraph()
    label     = @createLabel labelName
    label.appendTo paragraph
    textInput = @createTextField inputName, attrs
    textInput.appendTo paragraph
    paragraph

  createSubmitParagraph: (attrs) ->  
    paragraph = @createParagraph()
    submitButton = $("<input/>",
                     {
                       type: "submit",
                       value: attrs["value"],
                       width: "100px",
                       height: "40px"
                     }
                   )
    submitButton.appendTo paragraph
    paragraph

  createDiv: (attrs) ->
    $("<div/>", attrs)

  createUl: ->
    $("<ul/>")
 
  createLi: ->
    $("<li/>")

  createLink: (attrs) ->
    $("<a/>", attrs)

  createOption: (option) ->
    $("<option/>", {text: option[0], value: option[1]});

  createSelect: (attrs) ->
    select = $("<select/>", attrs["selectAttrs"])
    @createOption(option).appendTo(select) for option in attrs["options"]
    select

  createTabsDiv: (attrs) ->
    tabContainer = @createDiv attrs["divAttrs"]
    ul = @createUl()
    for index in [0..attrs["tabTitles"].length-1]
      li = @createLi() 
      link = @createLink {href: "#browserUtilTabs-#{index+1}", text: attrs["tabTitles"][index]}
      link.appendTo li
      li.appendTo ul
    ul.appendTo tabContainer
    for index in [0..attrs["tabTitles"].length-1]
      div = @createDiv({id: "browserUtilTabs-#{index+1}"})
      div.appendTo tabContainer

    tabContainer

  createSelectParagraph: (selectText, attrs) ->
    paragraph = @createParagraph()
    label = @createLabel selectText
    label.appendTo paragraph
    select = @createSelect attrs
    select.appendTo paragraph 
    paragraph

root = exports ? window
root.Html = Html
