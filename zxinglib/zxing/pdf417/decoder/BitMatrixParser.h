#ifndef __BIT_MATRIX_PARSER__PDF_H__
#define __BIT_MATRIX_PARSER__PDF_H__

/*
 *  BitMatrixParser.h / PDF417
 *  zxing
 *
 *  Copyright 2010 ZXing authors All rights reserved.
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
 */

#include <zxing/ReaderException.h>
#include <zxing/FormatException.h>
#include <zxing/common/BitMatrix.h>
#include <zxing/common/Counted.h>
#include <zxing/common/Array.h>

namespace zxing {
namespace pdf417 {

class BitMatrixParser : public Counted {
private:

#if _MSC_VER>=1300		//* 07.05.2012 hfn not for eMbedded c++ compiler
	static const int MAX_ROW_DIFFERENCE = 6;
	static const int MAX_ROWS = 90;
	// Maximum Codewords (Data + Error)
	static const int MAX_CW_CAPACITY = 929;
	static const int MODULES_IN_SYMBOL = 17;
#else
	static const int MAX_ROW_DIFFERENCE;
	static const int MAX_ROWS;
	// Maximum Codewords (Data + Error)
	static const int MAX_CW_CAPACITY;
	static const int MODULES_IN_SYMBOL;
#endif
	Ref<BitMatrix> bitMatrix_;
	int rows_; /* = 0 */
	int leftColumnECData_; /* = 0 */
	int rightColumnECData_; /* = 0 */
	/* added 2012-06-22 HFN */
	int aLeftColumnTriple_[3];
	int aRightColumnTriple_[3];
	int eraseCount_; /* = 0 */
	ArrayRef<int> erasures_;
	int ecLevel_; /* = -1 */
	
	static const int SYMBOL_TABLE_[];
	static const int SIZEOF_SYMBOL_TABLE_;
	static const int CODEWORD_TABLE_[];
	
public:
	BitMatrixParser(Ref<BitMatrix> bitMatrix);
	ArrayRef<int> getErasures() const {return erasures_;};
	int getECLevel() const {return ecLevel_;};
	ArrayRef<int> readCodewords(); /* throw(FormatException) */
	
private:
	bool VerifyOuterColumns();
	static ArrayRef<int> trimArray(ArrayRef<int> array, int size);
	static int getCodeword(unsigned long long symbol, int *pi);
	static int findCodewordIndex(unsigned long long symbol);
	int processRow(ArrayRef<int> rowCounters, int rowNumber, int rowHeight,
		ArrayRef<int> codewords, int next); /* throw(FormatException)  */ 
protected:
	static bool IsEqual(int a, int b);
};
 
} /* namespace pdf417 */
} /* namespace zxing */

#endif // __BIT_MATRIX_PARSER__PDF_H__
