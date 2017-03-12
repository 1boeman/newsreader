$(function(){
  $('.feed h3 a').click(function(e){
    e.preventDefault();
    $(this)
      .parents('.item')
      .find('.description')
      .toggle('visible');
  });



});
