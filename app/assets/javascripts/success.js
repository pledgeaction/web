$(window).load(function () {
  if ($('.pages.success').length) {
    $.ajax('/ref.json' + decodeURIComponent(window.location.search)).then(function (res) {
      //var url = "/success?ref_user=" + res.userUrl;
      //window.history.pushState('page2', 'The Pledge', url);
      
      //$('.referral').attr('href', url);
      //$('.referral-data').attr('data-href', url);

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