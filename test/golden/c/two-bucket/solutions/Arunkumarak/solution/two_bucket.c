#include "two_bucket.h"
#include <stdlib.h>
#include <stdio.h>
bucket_liters_t startBucketLevel = 0;
bucket_liters_t otherBucketLevel = 0;
void InitBucket(bucket_result_t *bucketToInit, bucket_id_t startBucket, bucket_id_t otherBucket)
{
   bucketToInit->possible = false;
   bucketToInit->move_count = 0;
   bucketToInit->goal_bucket = startBucket;
   bucketToInit->other_bucket_liters = otherBucket;
}
void FillEmptyBucket(bucket_result_t *bucketToFill, bucket_liters_t *bucketLevel, bucket_liters_t fillVolume)
{
   bucketToFill->move_count++;
   *bucketLevel = fillVolume;
}
bool CheckIfGoalVolumeIsInGoalBucket(bucket_result_t *bucketToFill, bucket_liters_t goalVolume)
{
   if(startBucketLevel == goalVolume)
   {
      bucketToFill->possible = true;
      bucketToFill->other_bucket_liters = otherBucketLevel;
      return true;
   }
   return false;
}
void OtherBucketHadGoalVolume(bucket_result_t *bucketToFill)
{
   bucketToFill->possible = true;
   bucketToFill->other_bucket_liters = startBucketLevel;
   if(bucketToFill->goal_bucket == BUCKET_ID_1)
   {
      bucketToFill->goal_bucket = BUCKET_ID_2;
   }
   else if(bucketToFill->goal_bucket == BUCKET_ID_2)
   {
      bucketToFill->goal_bucket = BUCKET_ID_1;
   }
}
bool CheckIfGoalVolumeIsInOtherBucket(bucket_result_t *bucketToFill, bucket_liters_t goalVolume)
{
   if(otherBucketLevel == goalVolume)
   {
      OtherBucketHadGoalVolume(bucketToFill);
      return true;
   }
   return false;
}
bool OtherBucketIsExactlyTheGoalVolume(bucket_result_t *bucketToFill, bucket_liters_t startBucketSize, bucket_liters_t goalVolume)
{
   if(bucketToFill->other_bucket_liters == goalVolume)
   {
      FillEmptyBucket(bucketToFill, &startBucketLevel, startBucketSize); // have to fill start bucket
      FillEmptyBucket(bucketToFill, &otherBucketLevel, goalVolume);
      OtherBucketHadGoalVolume(bucketToFill);
      return true;
   }
   return false;
}
bool CheckIfBothBucketsAreFull(bucket_result_t *bucketToFill, bucket_liters_t bucketOneSize)
{
   if(otherBucketLevel == bucketToFill->other_bucket_liters && startBucketLevel == bucketOneSize)
   {
      bucketToFill->possible = false;
      return true;
   }
   return false;
}
void PourGoalBucketIntoOtherBucket(bucket_result_t *bucketToFill)
{
   bucketToFill->move_count++;
   otherBucketLevel += startBucketLevel;
   if(otherBucketLevel > bucketToFill->other_bucket_liters) // handles overflow of other bucket
   {
      startBucketLevel = otherBucketLevel - bucketToFill->other_bucket_liters; // keeps excess in our bucket
      otherBucketLevel = bucketToFill->other_bucket_liters; // other bucket is topped off
   }
   else
   {
      startBucketLevel = 0; // our bucket completely pours in other bucket
   }
}
bool CheckIfEndCaseIsMet(bucket_result_t *bucketToFill, bucket_liters_t goalVolume, bucket_liters_t bucketOneSize)
{
   if(CheckIfGoalVolumeIsInGoalBucket(bucketToFill, goalVolume) == true)
   {
      return true;
   }
   else if(CheckIfGoalVolumeIsInOtherBucket(bucketToFill, goalVolume) == true)
   {
      return true;
   }
   else if(CheckIfBothBucketsAreFull(bucketToFill, bucketOneSize) == true)
   {
      return true;
   }
   return false;
}
void BucketAlgorithm(bucket_result_t *bucketToFill, bucket_liters_t bucketOneSize, bucket_liters_t goalVolume)
{
   if(CheckIfEndCaseIsMet(bucketToFill, goalVolume, bucketOneSize) == true)
   {
      return;
   }
   if(startBucketLevel == 0)
   {
      FillEmptyBucket(bucketToFill, &startBucketLevel, bucketOneSize);
   }
   else if(otherBucketLevel == 0)
   {
      PourGoalBucketIntoOtherBucket(bucketToFill);
   }
   if(CheckIfEndCaseIsMet(bucketToFill, goalVolume, bucketOneSize) == true)
   {
      return;
   }
   if(otherBucketLevel == bucketToFill->other_bucket_liters) // if the other bucket is filled, dump it
   {
      bucketToFill->move_count++;
      otherBucketLevel = 0;
   }
   if(startBucketLevel == bucketOneSize) // if our bucket is filled, pour it in the other bucket
   {
      PourGoalBucketIntoOtherBucket(bucketToFill);
   }
   BucketAlgorithm(bucketToFill, bucketOneSize, goalVolume);
   return;
}
bucket_result_t measure(
   bucket_liters_t bucket_1_size,
   bucket_liters_t bucket_2_size,
   bucket_liters_t goal_volume,
   bucket_id_t start_bucket)
{
   startBucketLevel = 0;
   otherBucketLevel = 0;
   bucket_result_t *outputBucket = (bucket_result_t *)malloc(sizeof(bucket_result_t));
   if(goal_volume > bucket_1_size && goal_volume > bucket_2_size)
   {
      outputBucket->possible = false;
      return *outputBucket;
   }
   if(start_bucket == BUCKET_ID_1)
   {
      InitBucket(outputBucket, start_bucket, bucket_2_size);
      if(OtherBucketIsExactlyTheGoalVolume(outputBucket, bucket_1_size, goal_volume) == false)
      {
         BucketAlgorithm(outputBucket, bucket_1_size, goal_volume);
      }
   }
   else
   {
      InitBucket(outputBucket, start_bucket, bucket_1_size);
      if(OtherBucketIsExactlyTheGoalVolume(outputBucket, bucket_1_size, goal_volume) == false)
      {
         BucketAlgorithm(outputBucket, bucket_2_size, goal_volume);
      }
   }
   return *outputBucket;
}
