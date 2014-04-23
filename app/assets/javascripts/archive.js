$(document).ready(function(){

    $('.submittable').click(function() {
        $(this).parents('form:first').submit();
    });

    $( ".well" ).click(function() {
  $( this ).toggleClass( "well-2" );
});
}); 