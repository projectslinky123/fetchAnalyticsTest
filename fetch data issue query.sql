declare @json varchar(max)

SELECT @json =  BulkColumn
 FROM OPENROWSET (BULK 'C:\Users\s\Desktop\receipts.json', SINGLE_CLOB) as j

/* Note: 
	The json file being imported is a modified file. It is not the original
	I opened the receipts.json file in a text editor and replaced all linebreaks with "," and enclosed all the contents with "[" at the begining and "]" at the end of the file.  */

/*** the join to receptItemList is not used in the identified data issue. The join to t2 can be removed if it is made into a validation rule and the query needs to be run on a regular basis   ******/

;with cte as
(	select t1._id,bonusPointsEarned,bonusPointsEarnedReason
		,createDate = cast(dateadd(day, cast(createDate as bigint)/(3600*24*1000), '1970-01-01 00:00:00.0') as date)
		,dateScanned = cast(dateadd(day, cast(dateScanned as bigint)/(3600*24*1000), '1970-01-01 00:00:00.0') as date)
		,finishedDate = cast(dateadd(day, cast(finishedDate as bigint)/(3600*24*1000), '1970-01-01 00:00:00.0') as date)
		,modifyDate = cast(dateadd(day, cast(modifyDate as bigint)/(3600*24*1000), '1970-01-01 00:00:00.0') as date) 
		,pointsAwardedDate = cast(dateadd(day, cast(pointsAwardedDate as bigint)/(3600*24*1000), '1970-01-01 00:00:00.0') as date)
		,receiptPointsEarned
		,purchaseDate = cast(dateadd(day, cast(purchaseDate as bigint)/(3600*24*1000), '1970-01-01') as date)
		,purchasedItemCount,rewardsReceiptStatus,totalSpent,userId
		, 'receiptitemlist'='receiptitemlist-->'
		, t2.* 
	FROM OPENJSON (@JSON) t 	
		outer apply (select * 
					from OPENJSON (t.value)  
					with (_id varchar(1000) '$._id."$oid"',
						bonusPointsEarned varchar(1000) '$.bonusPointsEarned',
						bonusPointsEarnedReason varchar(1000) '$.bonusPointsEarnedReason',
						createDate varchar(1000) '$.createDate."$date"',
						dateScanned varchar(1000) '$.dateScanned."$date"',
						finishedDate varchar(1000) '$.finishedDate."$date"',
						modifyDate varchar(1000) '$.modifyDate."$date"',
						pointsAwardedDate varchar(1000) '$.pointsAwardedDate."$date"',
						receiptPointsEarned varchar(1000) '$.pointsEarned',
						purchaseDate varchar(1000) '$.purchaseDate."$date"',
						purchasedItemCount varchar(1000) '$.purchasedItemCount',
						rewardsReceiptStatus varchar(1000) '$.rewardsReceiptStatus',
						totalSpent varchar(1000) '$.totalSpent',
						userId varchar(1000) '$.userId') ) t1
		outer apply OPENJSON (t.value,'$.rewardsReceiptItemList')  
			with (partnerItemId varchar(1000) '$.partnerItemId',
					userFlaggedPrice varchar(1000) '$.userFlaggedPrice',
					needsFetchReview varchar(1000) '$.needsFetchReview',
					originalMetaBriteQuantityPurchased varchar(1000) '$.originalMetaBriteQuantityPurchased',
					preventTargetGapPoints varchar(1000) '$.preventTargetGapPoints',
					metabriteCampaignId varchar(1000) '$.metabriteCampaignId',
					originalFinalPrice varchar(1000) '$.originalFinalPrice',
					originalMetaBriteBarcode varchar(1000) '$.originalMetaBriteBarcode',
					userFlaggedQuantity varchar(1000) '$.userFlaggedQuantity',
					barcode varchar(1000) '$.barcode',
					rewardsProductPartnerId varchar(1000) '$.rewardsProductPartnerId',
					targetPrice varchar(1000) '$.targetPrice',
					deleted varchar(1000) '$.deleted',
					rewardsGroup varchar(1000) '$.rewardsGroup',
					quantityPurchased varchar(1000) '$.quantityPurchased',
					pointsEarned varchar(1000) '$.pointsEarned',
					pointsNotAwardedReason varchar(1000) '$.pointsNotAwardedReason',
					originalMetaBriteDescription varchar(1000) '$.originalMetaBriteDescription',
					priceAfterCoupon varchar(1000) '$.priceAfterCoupon',
					userFlaggedNewItem varchar(1000) '$.userFlaggedNewItem',
					itemNumber varchar(1000) '$.itemNumber',
					userFlaggedBarcode varchar(1000) '$.userFlaggedBarcode',
					description varchar(1000) '$.description',
					competitorRewardsGroup varchar(1000) '$.competitorRewardsGroup',
					pointsPayerId varchar(1000) '$.pointsPayerId',
					userFlaggedDescription varchar(1000) '$.userFlaggedDescription',
					competitiveProduct varchar(1000) '$.competitiveProduct',
					finalPrice varchar(1000) '$.finalPrice',
					itemPrice varchar(1000) '$.itemPrice',
					originalMetaBriteItemPrice varchar(1000) '$.originalMetaBriteItemPrice',
					needsFetchReviewReason varchar(1000) '$.needsFetchReviewReason',
					originalReceiptItemText varchar(1000) '$.originalReceiptItemText') t2 )

select 'Receipts where the dateScanned is before the datepurchased. This would mean the receipts were scanned before the receipt was created.', count(distinct _id)
from cte
where dateScanned < purchaseDate

/* There is likely an issue with the month of the purchase date. the date scanned seems more likely to be be correct as it lines up with the other dates like create date and finish date.   */


/***** other queries uses  ****/

--select _id,bonusPointsEarned,bonusPointsEarnedReason,createDate,dateScanned,finishedDate,modifyDate,pointsAwardedDate,receiptPointsEarned,purchaseDate,purchasedItemCount,rewardsReceiptStatus,totalSpent,userId,receiptitemlist,partnerItemId,userFlaggedPrice,needsFetchReview,originalMetaBriteQuantityPurchased,preventTargetGapPoints,metabriteCampaignId,originalFinalPrice,originalMetaBriteBarcode,userFlaggedQuantity,barcode,rewardsProductPartnerId,targetPrice,deleted,rewardsGroup,quantityPurchased,pointsEarned,pointsNotAwardedReason,originalMetaBriteDescription,priceAfterCoupon,userFlaggedNewItem,itemNumber,userFlaggedBarcode,description,competitorRewardsGroup,pointsPayerId,userFlaggedDescription,competitiveProduct,finalPrice,itemPrice,originalMetaBriteItemPrice,needsFetchReviewReason,originalReceiptItemText 
--from cte
--where bonusPointsEarned is not null

--select userid, count(*)
--from cte
----where rewardsReceiptStatus <> 'SUBMITTED' --coalesce(barcode,'') in ('','4011')
--group by userid
--order by 2 desc

--select *, receiptsWithNullSpend = count(_id) over (partition by '1') 
--from cte
--where totalspent is null --coalesce(barcode,'') in ('','4011')

