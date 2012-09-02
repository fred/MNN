# encoding: utf-8
require 'spec_helper'
include FastGettext::Translation

describe "Locale" do

  describe "Using FastGettext" do

    describe "For EN locale" do
      before(:each) do
        FastGettext.locale = 'en'
      end
      it "should tranlate 'Password' => 'Password'" do
        assert_equal "Password", _('Password')
      end
      it "should tranlate 'Sign out' => 'Sign out'" do
        assert_equal "Sign out", _('Sign out')
      end
    end

    describe "For NL locale" do
      before(:each) do
        FastGettext.locale = 'nl'
      end
      it "should tranlate 'Password' => 'Wachtwoord'" do
        assert_equal "Wachtwoord", _('Password')
      end
      it "should tranlate 'Sign out' => 'Uitloggen'" do
        assert_equal "Uitloggen", _('Sign out')
      end
    end

    describe "For ES locale" do
      before(:each) do
        FastGettext.locale = 'es'
      end
      it "should tranlate 'Password' => 'Contraseña'" do
        assert_equal "Contraseña", _('Password')
      end
      it "should tranlate 'Sign out' => 'Salir'" do
        assert_equal  "Salir", _('Sign out')
      end
    end

    describe "For pt_BR locale" do
      before(:each) do
        FastGettext.locale = 'pt'
      end
      it "should tranlate 'Password' => 'Senha'" do
        assert_equal "Senha", _('Password')
      end
      it "should tranlate 'Sign out' => 'Encerrar Sessão'" do
        assert_equal "Encerrar Sessão", _('Sign out')
      end
    end

  end




  describe "Using I18n" do

    describe "For EN locale" do
      before(:each) do
        I18n.locale = :en
      end
      it "should tranlate 'Password' => 'Senha'" do
        assert_equal "Password", _('Password')
      end
      it "should tranlate 'Sign out' => 'Sign out'" do
        assert_equal "Sign out", _('Sign out')
      end
    end

    describe "For NL locale" do
      before(:each) do
        I18n.locale = :nl
      end
      it "should tranlate 'Password' => 'Wachtwoord'" do
        assert_equal "Wachtwoord", _('Password')
      end
      it "should tranlate 'Sign out' => 'Uitloggen'" do
        assert_equal "Uitloggen", _('Sign out')
      end
    end

    describe "For ES locale" do
      before(:each) do
        I18n.locale = :es
      end
      it "should tranlate 'Password' => 'Contraseña'" do
        assert_equal "Contraseña", _('Password')
      end
      it "should tranlate 'Sign out' => 'Salir'" do
        assert_equal  "Salir", _('Sign out')
      end
    end

    describe "For PT locale" do
      before(:each) do
        I18n.locale = :pt
      end
      it "should tranlate 'Password' => 'Senha'" do
        assert_equal "Senha", _('Password')
      end
      it "should tranlate 'Sign out' => 'Encerrar Sessão'" do
        assert_equal "Encerrar Sessão", _('Sign out')
      end
    end

  end


end
