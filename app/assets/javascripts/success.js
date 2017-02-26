
$(window).load(function () {
  if ($('.pages.success').length) {
    $.ajax('/ref.json' + decodeURIComponent(window.location.search)).then(function (res) {
      console.log(res);
      $('a.referral.ui-link').attr('href', "/?ref_user=" + res.userUrl);
    });
  }
});