package SPPM::Web::Controller::Login;
use Moose;
use utf8;
use HTML::FormHandler;

BEGIN {extends 'Catalyst::Controller'; }


sub login : Path('/login') : Args(0) {
    my ( $self, $c ) = @_;

        my $form = HTML::FormHandler->new({
            field_list => [
              username => {
                  type => 'Text',
                  label => 'Login',
                  required => 1,
                  required_message => 'Campo Requerido',
                  },
              password => {
                  type => 'Password',
                  label => 'Password',
                  required => 1,
                  required_message => 'Campo Requerido',
                  },
              submit => {
                  type => 'Submit',
                  value => 'Login',
                  },
              ],
            });
#       $c->stash( template => \$form->render);
    $c->stash( template => \<<FBLOGIN
    <p><fb:login-button autologoutlink="true"></fb:login-button></p>
    <p><fb:like></fb:like></p>

    <div id="fb-root"></div>
    <script>
      window.fbAsyncInit = function() {
        FB.init({appId: '171501766212404', status: true, cookie: true,
                 xfbml: true});
      };

alert('logando');
  FB.Event.subscribe('auth.sessionChange', function(response) {
    if (response.session) {
      // A user has logged in, and a new cookie has been saved
	alert(response);
	alert(response.session);
    } else {
      // The user has logged out, and the cookie has been cleared
    }
  });












      (function() {
        var e = document.createElement('script');
        e.type = 'text/javascript';
        e.src = document.location.protocol +
          '//connect.facebook.net/en_US/all.js';
        e.async = true;
        document.getElementById('fb-root').appendChild(e);
      }());
    </script>
FBLOGIN
);

    # Get the username and password from form
    my $username = $c->request->params->{username} || undef;
    my $password = $c->request->params->{password} || undef;

    # If the username and password values were found in form
    if ( defined($username) && defined($password) ) {

        # Attempt to log the user in
        if (
            $c->authenticate(
                {
                    username => $username,
                    password => $password
                }
            )
          )
        {

            $c->forward(qw/SPPM::Web::Controller::Root index/);

            return;
        }
        else {

            # Set an error message
            $c->stash->{error_msg} =
 "Login desconhecido. Verifique seu login e senha e tente novamente. ";
        }
    }

    # If either of above don't work out, send to the login page
    $c->detach(qw/SPPM::Web::Controller::Root index/) if ($c->user_exists);
}




sub logout : Path('/logout') : Args(0) {
    my ( $self, $c ) = @_;

    # Clear the user's state
    $c->logout;

    # Send the user to the starting point
    $c->response->redirect( $c->uri_for('/') );
}





















































































































































































































































































































































































































































































































1;
