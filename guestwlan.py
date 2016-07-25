#!/usr/bin/env python

import ConfigParser
from glob import glob
from os.path import join, dirname
from kivy.app import App
from kivy.core.window import Window
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.screenmanager import ScreenManager, Screen
from kivy.uix.image import Image
from kivy.properties import ObjectProperty, StringProperty, NumericProperty
from kivy.uix.widget import Widget
from kivy.clock import Clock

# from kivy.logger import Logger

class WLAN(Screen):
    wlanssid = StringProperty(None)
    wlanpsk = StringProperty(None)
    android_qrcode = ObjectProperty(None)
    ios_qrcode = ObjectProperty(None)
    windows_qrcode = ObjectProperty(None)
    refresh = NumericProperty(1)

    def reload(self, dummy):
        wlancfg = ConfigParser.RawConfigParser()
        wlancfg.read('/var/guestwlan/wlan.cfg')
        self.wlanssid = wlancfg.get('WLAN', 'wlanssid')
        self.wlanpsk = wlancfg.get('WLAN', 'wlanpsk')
        self.refresh = float(wlancfg.get('WLAN', 'refresh'))
        self.android_qrcode.reload()
        self.ios_qrcode.reload()
        self.windows_qrcode.reload()
        return self.refresh

class ScreenManagement(ScreenManager):
    pass

class GuestWLAN(BoxLayout):
    pass

class GuestWLANApp(App):
    def build(self):
        global SM
        # the root is created in the KV file
        SM = self.root

        InfoQr = SM.get_screen('wlan')
        interval = float(InfoQr.reload(1))
        Clock.schedule_interval(InfoQr.reload, interval)

        return SM

if __name__ == "__main__":
    GuestWLANApp().run()
