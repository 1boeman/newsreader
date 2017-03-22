$(function(){
  $('.feed h3 a').click(function(e){
    e.preventDefault();
    $(this)
      .parents('.item')
      .find('.description')
      .toggle('visible');
  });

  $.scrollUp({  
    animation: 'fade',
    scrollImg: { active: true, type: 'background' }
  });
});
