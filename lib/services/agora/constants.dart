// Fill in the app ID obtained from the Agora console
import 'dart:math';

const appId = "74a59dd9901c41bf86776f3bcee5523c";
// Fill in the temporary token generated from Agora Console
const token =
    "007eJxTYOB1qnLwfJsi9TpvLUsVs9s8Y8biQx96DP2W9v11Wl20q0SBwdwk0dQyJcXS0sAw2cQwKc3CzNzcLM04KTk11dTUyDj5kPHM9IZARobyZ6YMjFAI4rMxZKQm5qQWMTAAAAk3HwE=";
// Fill in the channel name you used to generate the token
const channel = "healer";

int generateRandomSixDigitNumber() {
  final random = Random();
  return 100000 + random.nextInt(900000);
}

int uid = generateRandomSixDigitNumber();

// const rtmToken =
//     "007eJxSYDAyTVCRKNe7GhG+ztv859OWuzdqL+gs0n5t+X9mseu6gvsKDOYmiaaWKSmWlgaGySaGSWkWZubmZmnGScmpqaamRsbJosunpTcEMjJsLf/IzMjAxMDIwMgA4jMwAAIAAP//oZ4evg==";
