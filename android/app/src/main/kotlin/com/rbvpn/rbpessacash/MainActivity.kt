package com.rbvpn.rbpessacash

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import id.laskarmedia.openvpn_flutter.OpenVPNFlutterPlugin

class MainActivity: FlutterActivity() {
   
   //public static final int REQUEST_CODE = 1;

    @Override

    protected override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        OpenVPNFlutterPlugin.connectWhileGranted(requestCode == 24 && resultCode == RESULT_OK);
        super.onActivityResult(requestCode, resultCode, data)
       

}


    }



