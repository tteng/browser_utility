###
// ==UserScript==
// @name        browser_util
// @namespace   bu
// @description grab spcified xpaths on page, submits to server
// @exclude     http://localhost*
// @author      Tim.Teng<shreadline#gmail.com>
// @version     1
// @grant       GM_addStyle
// @grant       GM_getResourceText
// @require     http://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js
// @require     http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/jquery-ui.min.js
// @resource    jqUI_CSS http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.1/themes/smoothness/jquery-ui.css
// @require     doms.js
// ==/UserScript==
###

### run once on frame pages ###
return if frameElement

jqUI_CssSrc = GM_getResourceText "jqUI_CSS"
GM_addStyle jqUI_CssSrc

### enable jquery for monkey ###
this.$ = this.jQuery = jQuery.noConflict true

html = new Html()

### list page start ###
listForm = html.createForm {id: "your_form_id", action: "your api path", "data-remote": true, method: "POST", "accept-charset": "UTF-8"}

inputParaGraph = html.createInputParagraph "Some label", "obj[input_attr]"
inputParaGraph.appendTo listForm

selectParagraph = html.createSelectParagraph("some select",
  {
    selectAttrs: {
      name: "obj[select_attr]",
      height: "40px",
      width:  "80px"
    },
    options: [
      ['否', 0],
      ['是', 1]
    ]
  }
);
selectParagraph.appendTo listForm

submit = html.createSubmitParagraph {value: "提交", css: {}}
listForm.append submit

### list page end ###

### another page start  ###
anotherForm = html.createForm {id: "another_form_id", action: "http://localhost:3000/api/source_sites", "data-remote": true, method: "POST", "accept-charset": "UTF-8"}

anotherInputGraph = html.createInputParagraph "Another Label", "obj[another_attr]", {}
anotherInputGraph.appendTo anotherForm

textParagraph  = html.createInputParagraph "Text Paragraph", "obj[text_attr]", {
  inputType: "textarea",
  placeholder: "some place holder"
}
textParagraph.appendTo anotherForm

submit = html.createSubmitParagraph {value: "提交"}
anotherForm.append submit

### another page end ###

tabs = html.createTabsDiv {
  divAttrs: {
    id: "tabsDiv",
    css: {
      position: "fixed",
      top:  "10px",
      left: "10px",
      padding: "20px",
      width: "70px",
      height: "70px",
      ###opacity: "0.8",###
      border: "1px",
      "overflow-y": "scroll",
      ###"overflow-x": "hidden"###
      "overflow-x": "scroll",
      "border-color": "black",
      "background-color": "white"
    }
  },
  tabTitles: [
    "First Tab",
    "Second Tab"
  ]
}

tabs.appendTo $("body")
listForm.appendTo $('#browserUtilTabs-1')
anotherForm.appendTo $('#browserUtilTabs-2')

tabs.zIndex(1000);

$ ->
  $("#tabsDiv").tabs()
  $("#tabsDiv").attr "minimum", "true"
  $("#tabsDiv").dblclick ->
    if $(this).attr("minimum") is "true"
      $("#tabsDiv").attr "minimum", "false"
      $("#tabsDiv").animate {
        width:  '640px',
        height: '500px'
      }, 500
    else
      $("#tabsDiv").attr "minimum", "true"
      $("#tabsDiv").animate({
        width:  "70px",
        height: "70px"
      }, 500).effect "highlight",{color: "yellow"}, 1000

  $("#your_form_id, #another_form_id").each( ->
    $(this).dblclick (event) ->
      event.stopPropagation();
      ### stop passing event to parent ###
  );
  ### override default tabs header background gray color ###
  $('.ui-widget-header').css("background-color", "white").css("border-color", "white");

  $("#your_form_id").submit (e)->
    e.preventDefault()
    postData = $(this).serializeArray()
    formURL =  $(this).attr "action"
    $.ajax(
      {
        url : formURL,
        type: "POST",
        data : postData,
        success: (response) ->
                   if response.success
                     alert '保存成功'
                     alert response.data
                   else
                     alert '保存失败'
                     alert response.data
                     alert response.error
        error: ->
                 alert 'faild'
                 alert response.data
                 alert response.error
      }
    )
