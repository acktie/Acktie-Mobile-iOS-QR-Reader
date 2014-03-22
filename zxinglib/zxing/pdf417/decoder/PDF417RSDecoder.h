/* Copyright 2011 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * 
 * Ported from:
 *
 *  Pdf417decode.c
 *
 *   Original software by Ian Goldberg, 
 *   Modified and updated by OOO S.  (ooosawaddee3@hotmail.com)
 *   Version 2.0 by Hector Peraza (peraza@uia.ua.ac.be)
 *
 *   History:
 *
 *   22/12/01  pdf417decode             Initial Release
 *   23/12/01  pdf417decode rev 1.1     Added a test to see if fopen() suceeded.
 *   07/03/04  pdf417decode rev 2.0     Decoding routines heavily modified.
 *                                      Fixed start-of-row symbol problem.
 *                                      Numeric and text compactions now supported.
 * 2012-06-05 PDF417RSDecoder.h   HFN   ported from Java into C++
 *                                   
 */

#ifndef _PDF417RSDECODER_H__ 
#define _PDF417RSDECODER_H__ 

#include <zxing/Result.h>
#include <zxing/pdf417/decoder/Decoder.h>
#include <zxing/pdf417/decoder/BitMatrixParser.h>
#include <zxing/pdf417/decoder/DecodedBitStreamParser.h>
#include <zxing/ReaderException.h>
#include <zxing/common/reedsolomon/ReedSolomonException.h>

namespace zxing {
namespace pdf417 {

class PDF417RSDecoder: public Counted {
private:
  static const int NN;
  static const int PRIM;
  static const int GPRIME;
  static const int KK;
  static const int A0;

  ArrayRef<int> Powers_Of_3; // Powers of 3 in Galois Field(929) originally "Alpha_to_"
  ArrayRef<int> Discrete_Log_3; // Discrete logarithms to Base 3 in GF(929), originally "Index_of_"

  bool rs_init_;
  
  void powers_init();
  static int modbase(int x);
  
  void print(const char *pc);

public:  
  PDF417RSDecoder();
  virtual ~PDF417RSDecoder();
  
  int correctErrors(ArrayRef<int> data, ArrayRef<int> eras_pos, int no_eras, int data_len, int synd_len);
};

} /* namespace pdf417 */
} /* namespace zxing */
  
#endif // #ifndef _PDF417RSDECODER_H__ 
