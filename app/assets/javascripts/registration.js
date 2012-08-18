if ($("form#new_user")){
  $("form#new_user").validate({
    rules: {
      "user[email]": {required: true, minlength: 4},
      "user[password]": {required: true, minlength: 6},
      "user[password_confirmation]": {required: true, minlength: 6}
    },
    showErrors: function(errors){
      $.each(this.errorList, function(index, value){
        $(value.element).parent().parent().addClass('error');
        $(value.element).attr('rel', 'tooltip');
        $(value.element).attr('title', value.message);
      });
      $("[rel='tooltip']").tooltip({
        placement: 'right',
        trigger: 'hover'
      });
    }
  });
}
if ($("form#edit_user")){
  $("form#edit_user").validate({
    rules: {
      "user[email]": {required: true, minlength: 4}
    },
    showErrors: function(errors){
      $.each(this.errorList, function(index, value){
        $(value.element).parent().parent().addClass('error');
        $(value.element).attr('rel', 'tooltip');
        $(value.element).attr('title', value.message);
      });
      $("[rel='tooltip']").tooltip({
        placement: 'right',
        trigger: 'hover'
      });
    }
  });
};


if ($("#user_password")){
  $("#user_password").complexify({
      minimumChars: 6,
      strengthScaleFactor: 0.6
    },
    function (valid, complexity) {
      if (!valid) {
        $('#progress').css({'width':complexity + '%'}).removeClass('progressbarValid').addClass('progressbarInvalid');
      } else {
        $('#progress').css({'width':complexity + '%'}).removeClass('progressbarInvalid').addClass('progressbarValid');
      }
      $('#complexity').html(Math.round(complexity) + '%');
    }
  );
};