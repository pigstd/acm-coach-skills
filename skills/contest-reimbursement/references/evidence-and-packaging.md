# Evidence and packaging reference

Use the receiving unit's documented rules and the user's confirmed exceptions together with the completed reference packages. Apply this matrix as a starting point for reviewing evidence.

## Evidence matrix

| Expense | Invoice or ticket evidence | Supporting evidence and matching fields |
|---|---|---|
| Contest purpose | Sealed invitation or contest notice for each contest | Verify the seal visually and check the contest name, dates, venue, fee, and authorized collector |
| Registration | Registration, contest-service, or conference-fee invoice | Payment record where required, fee per team and number of teams |
| Train | Railway electronic ticket for each traveler and journey | Payment record where required, name/date/train/route/seat; order details when existing tickets leave an ambiguity |
| Airfare | Airline electronic ticket itinerary or the available platform booking-service invoice | Booking and payment details, all travelers and directions, route/flight/date/cabin, fare and add-on breakdown |
| Hotel | Accommodation or booking-service invoice | Hotel order/stay record, check-in/check-out, room type/count, nights, actual guest count, payment details where required |
| Ride-hailing | Passenger-transport invoice | Platform itinerary with date, pickup/dropoff, trip amount and payer association |
| Tolls | Toll invoice | Corresponding journey and payment relation, with separate amounts counted once |

Supporting facts can span documents. An accommodation invoice can provide room/nights details while an order provides dates and payment status. A complete order may carry sufficient payment information for the convention being followed. A platform payment merchant can differ from the invoice issuer. Check order identifiers and hotel details.

Write a separate Chinese accommodation remark if the invoice remarks omit the check-in date, check-out date, number of nights, or actual guest count. Example: `5 月 X 日入住，5 月 X 日离店，共住 X 晚，实际入住 X 人，共 X 间。` If the user confirms that the actual guests are the people covered by the contest's travel tickets, count distinct travelers once across tickets and directions. Use this confirmed total even if the booking lists fewer guest names. For multiple invoices, give the confirmed group total and include invoice-level guest counts only when supported. Preserve original invoices. If the receiving unit specifically requires these details in the invoice's own remarks field, flag the need for an updated invoice from the issuer.

For airline materials, inspect the actual document title. PDF and OFD describe formats, while `航空运输电子客票行程单` and `代订机票款` identify different document types. Completed packages can contain individual airline itineraries and a shared order/payment screenshot. Report that pattern when asked. If the current materials use a combined platform invoice, keep it intact and describe the resulting difference in the summary. Their acceptance depends on the applicable receiving-unit guidance.

An original invoice can be supplied as PDF, OFD, XML, or an invoice image. Deduplicate by invoice/ticket number and content. Two invoices of the same amount with distinct numbers remain separate expenses. Flag same-number versions with differing amounts/statuses for inspection.

## Reconciliation examples

These examples illustrate decisions. Use the current task's actual values and confirmed treatment.

| Situation | Handling |
|---|---|
| Two travelers each have outbound and return train tickets, paid in two group transactions | Match each group debit to its direction and two tickets. Count four ticket expenses and two supporting payments |
| Order 305.00, payment discount 0.05, actual debit 304.95, invoice 305.00 | Show invoice 305.00, discount 0.05, and actual debit 304.95. Apply the confirmed amount convention; otherwise propose 304.95 and disclose the choice |
| One group payment covers 2,400.00 in fare and 120.00 in separately invoiced delay-compensation products | Reconcile 2,520.00 once. When the user asks to include the products in airfare, put both sets of invoices under `机票费-2520.00` |
| A user-confirmed payment-record waiver applies strictly below 1,000.00 | A qualifying 600.00 invoice is marked exempt from that attachment. A 1,000.00 invoice remains outside that particular waiver. Record applicability for the relevant unit/workflow |
| Two hotel orders differ only in their check-in code | Keep both. Inspect order identifiers or further details before assigning a particular invoice/payment to each room |
| Invoice remarks show an earlier flight time, and the final order shows a schedule change | Keep the change/final-order evidence and identify the final journey; check whether an updated invoice is available if the mismatch affects required fields |
| Payment screenshot belongs to another month and route | Exclude it from the target contest package and explain the mismatch in the review |
| Existing example omits one itinerary or one fee category | Describe the observed omission. Establish any requirement or exemption from the user's instructions or applicable rules |

Use financial values as `Decimal` or integer minor units. Keep `invoice amount`, `order amount`, `payment discount`, `actual debit`, and `proposed reimbursement` distinct in working calculations. Derive differences from evidence and retain both totals when necessary. A platform discount should not silently change the invoice amount written in its filename.

## Suggested layout

```text
比赛名称报销-总额/
  比赛通知（盖章版）.pdf
  费用汇总及凭证说明.txt
  报名费-小计/
    报名费发票-金额.pdf
    报名费支付记录-金额.png
  火车票-小计/
    姓名-去程-日期-起点至终点-车次-金额.pdf
    姓名-返程-日期-起点至终点-车次-金额.pdf
    去程支付记录-金额.png
    返程支付记录-金额.png
    原始OFD/
  机票费-小计/
    去程-日期-航线-现有票据类型-金额.pdf或ofd
    返程-日期-航线-现有票据类型-金额.pdf或ofd
    往返订单及付款截图.png
    延误赔-小计/
    发票XML/
  酒店费-小计/
    住宿报销备注.txt
    住宿费发票-发票号码-票面金额.pdf
    酒店订单1-日期-房型间夜数.png
    酒店订单2-日期-房型间夜数.png
    酒店付款1-日期时间-实付金额.png
    酒店付款2-日期时间-实付金额.png
  打车费-小计/
    垫付人或城市-小计/
      发票.pdf
      行程单.pdf
      对应通行费发票.pdf
```

Use only the folders applicable to the actual expenses. An itinerary may cover several rides; a shared payment may cover several invoice folders. Refer to that coverage in the summary rather than adding it to multiple subtotals. For a multi-person flight invoice, put `多人合开` in its output filename when useful. Individual original tickets can instead use traveler names. Preserve the original extension.

## Expense summary contents

Keep the summary concise and in the user's language. Include the contest/date/location, amounts by category, and proposed total. Add invoice versus debit totals if different. Document any payment-record exemption with its user-confirmed scope, add-on inclusion, shared-payment coverage, source of a discount, and genuine unresolved gaps or unassigned matches.

Preserve monetary values in invoice filenames. Category and root names follow the proposed reimbursement subtotals. For example, a hotel folder can be named for actual debits while its original invoice filenames retain their higher face amounts. Explain the difference once in the summary.

When updating a package, inspect both the folder and ZIP before replacing them. Include any user-added attachments. Verify the replacement before retiring a superseded agent-generated ZIP and check that the final summary has no stale total or resolved pending item.
