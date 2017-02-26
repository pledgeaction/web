$(window).load(function () {
  if ($('.pages.success').length) {
    $.ajax('/ref.json' + decodeURIComponent(window.location.search)).then(function (res) {
      $('a.referral.ui-link').attr('href', "/?ref_user=" + res.userUrl);
      // $('.button.facebook').click(function () {
      //   FB.ui({
      //       method: 'share',
      //       href: 'http://www.pledgeaction.org?ref_user=' + res.userUrl,
      //       quote: "Take the Pledge!"
      //   });
      // });
    });

  }
});