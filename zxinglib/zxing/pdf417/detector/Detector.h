#ifndef __DETECTOR_PDF_H__
#define __DETECTOR_PDF_H__

/*
 *  Detector.h
 *  zxing
 *
 *  Created by Hartmut Neubauer 2012-05-25
 *  Copyright 2010,2012 ZXing authors All rights reserved.
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

#include <zxing/common/Counted.h>
#include <zxing/common/DetectorResult.h>
#include <zxing/common/BitMatrix.h>
#include <zxing/BinaryBitmap.h>
#include <zxing/common/PerspectiveTransform.h>
#include <zxing/ResultPointCallback.h>
#include <zxing/common/detector/WhiteRectangleDetector.h>
#include <zxing/NotFoundException.h>
#include <zxing/DecodeHints.h>
#include <vector>
/*
#if 1
#define POINTARRAYREF	std::vector<Ref<ResultPoint> >
#define ALLOC_POINTARRAY
#define POINTARR_DEREF	->
#else
// nicht: 
#define POINTARRAYREF ArrayRef<ResultPoint>; 
#define ALLOC_POINTARRAY = new Array<ResultPoint>
#define POINTARR_DEREF	.
#endif
*/

namespace zxing {
namespace pdf417 {

class Detector {
private:
  static const int MAX_AVG_VARIANCE;
  static const int MAX_INDIVIDUAL_VARIANCE;
  static const int SKEW_THRESHOLD;
  static const int START_PATTERN_[];
  static const int START_PATTERN_REVERSE_[];
  static const int STOP_PATTERN_[];
  static const int STOP_PATTERN_REVERSE_[];
  static const int SIZEOF_START_PATTERN_;
  static const int SIZEOF_START_PATTERN_REVERSE_;
  static const int SIZEOF_STOP_PATTERN_;
  static const int SIZEOF_STOP_PATTERN_REVERSE_;

  Ref<BinaryBitmap> image_;
  static Ref<PerspectiveTransform> transform_;
    
  static std::vector<Ref<ResultPoint> > findVertices(Ref<BitMatrix> matrix);
  static std::vector<Ref<ResultPoint> > findVertices180(Ref<BitMatrix> matrix);
  static void correctCodeWordVertices(std::vector<Ref<ResultPoint> > &vertices,
			bool upsideDown);
  static float computeModuleWidth(std::vector<Ref<ResultPoint> > &vertices);
  //static float computeModuleWidth(ResultPoint* vertices);
  static int computeDimension(Ref<ResultPoint> topLeft,
			  Ref<ResultPoint> topRight,
			  Ref<ResultPoint> bottomLeft,
			  Ref<ResultPoint> bottomRight,
			  float moduleWidth);
  static Ref<BitMatrix> sampleGrid(Ref<BitMatrix> matrix,
			  Ref<ResultPoint> topLeft,
			  Ref<ResultPoint> bottomLeft,
			  Ref<ResultPoint> topRight,
			  Ref<ResultPoint> bottomRight,
			  int dimension);
  static Ref<PerspectiveTransform> createTransform(Ref<ResultPoint> topLeft,
			Ref<ResultPoint> topRight, Ref<ResultPoint> bottomLeft, Ref<ResultPoint> bottomRight,
			int dimensionX, int dimensionY);
  static int round(float d);
  static ArrayRef<int> findGuardPattern(Ref<BitMatrix> matrix,
				int column,
				int row,
				int width,
				bool whiteFirst,
				const int pattern[],
				unsigned int pattern_size,
				ArrayRef<int> counters);
  static int patternMatchVariance(ArrayRef<int> counters, const int pattern[],
			int maxIndividualVariance);

 public:
   Detector(Ref<BinaryBitmap> image);
   Ref<BinaryBitmap> getImage();
   Ref<DetectorResult> detect();
   Ref<DetectorResult> detect(DecodeHints const& hints);
};

}
}

#endif // __DETECTOR_PDF_H__