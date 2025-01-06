// Fill in the app ID obtained from the Agora console
import 'dart:math';

const appId = "74a59dd9901c41bf86776f3bcee5523c";
// Fill in the temporary token generated from Agora Console
const token =
    "007eJxTYFhR57sh+qnlo/bvx896PAn2DYjzbr64kFXzboT0ci7NrgIFBnOTRFPLlBRLSwPDZBPDpDQLM3NzszTjpOTUVFNTI+Pk6CNV6Q2BjAypsVtYGRkgEMRnY8hITcxJLWJgAACpXiBI";
// Fill in the channel name you used to generate the token
const channel = "healer";

int generateRandomSixDigitNumber() {
  final random = Random();
  return 100000 + random.nextInt(900000); 
}

int uid = generateRandomSixDigitNumber();
