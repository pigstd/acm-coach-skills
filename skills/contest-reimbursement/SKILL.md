---
name: contest-reimbursement
description: Check and assemble ACM/ICPC/CCPC contest travel reimbursement materials from local folders, nested ZIPs, invoices, orders, payment screenshots, and completed reference packages. Use when a coach asks what is missing from 报销材料, needs likely payment dates, supplies additional receipts, or wants a submission folder and ZIP organized to an established format.
---

# Contest Reimbursement

Inspect the actual evidence, reconcile expenses, and prepare a local reimbursement package using the coach's completed examples and confirmed handling rules.

## Establish the applicable conventions

Use the current request and earlier confirmations to identify the contest, source files, reference packages, invoice purchaser details, and output location. Organization defaults may come from the suite's local configuration. Discover existing sources before asking for values.

Keep a distinction between the receiving unit's rules, observed practices in completed packages, and a handling choice confirmed by the user. Examples establish an output convention. Formal eligibility, limits, approval procedures, and deadlines require their own evidence.

Apply confirmed exceptions throughout the task. For example, if the user confirms that this unit waives payment records for expenses strictly below a threshold, mark qualifying expenses as exempt and continue preparing the package. Preserve the strict boundary and scope. Record the confirmation in the package summary. Persist an institution-specific rule only in user-authorized local records outside this repository.

When the user asks to follow their completed packages, inspect those packages directly. Another faculty's published guidance may offer context, but cannot establish the receiving faculty's acceptance of a different invoice type. Browse current official guidance when the user asks about formal policy, and identify which unit issued it.

## Inspect folders and archives

Inventory the working folder, outer ZIP, and nested ZIPs. Compare their contents when they may represent different revisions. Inspect the members of a ZIP before reporting missing evidence. PDF and OFD versions of the same invoice count as one expense.

Use available local PDF/image libraries or the environment's document runtime. Read text-bearing PDFs, inspect scanned pages and screenshot details visually, and use OCR when necessary. OFD is a fixed-layout container format. Text can often be inspected in its XML, and an OFD viewer or renderer can verify its layout. A filename or extension alone does not establish the invoice type.

For ZIP member names, honor UTF-8 flags and recover legacy Chinese encodings when needed. Read selected members directly or validate extraction paths before unpacking. Resolve destinations within the intended working directory and reject traversal paths. Retain original bytes and source locations.

Capture the following where present in a temporary evidence ledger or the requested local report.

- Invoice number, type, purchaser name and tax identifier, issuer, date, and tax-inclusive total.
- Traveler, route, flight/train number, departure date, direction, and ticket number.
- Hotel, stay dates, room type, room count, nights, and order identifier.
- Payment status, date/time, merchant, order amount, discount, actual debit, and transaction/order identifier.
- Source file or archive member, matching evidence, and any unresolved association.

Use identifiers and content to detect duplicate invoices and screenshots. Equal amounts alone are insufficient. Similar hotel screenshots can differ in one character of the booking/check-in code. Inspect at sufficient resolution before merging records.

Read [references/evidence-and-packaging.md](references/evidence-and-packaging.md) for the evidence matrix, common reconciliation cases, and output layout.

## Review expenses and answer missing-material requests

Match each expense to its business purpose, formal invoice/ticket, order or itinerary, and payment evidence required by the applicable convention. Support one payment covering several travelers, directions, or invoice categories. Identify the covered expenses and count the payment once.

Check every traveler and direction when the references use individual tickets. Distinguish an airline-issued electronic itinerary from a platform's multi-person booking-service invoice. If only a platform invoice is available, retain it, explain the difference from the examples, and organize the materials the user has authorized. Keep a missing-material finding proportional to the requested review. Never fabricate individual invoices or divide a multi-person original into purported official tickets.

Treat invoice issuer and payment merchant differences as a matching question. Organizer-authorized collection agents and hotel booking platforms may legitimately differ from the contest organizer or hotel brand. Use the notice and orders to connect them. Report uncertainty when the available identifiers cannot connect individual invoices to individual orders.

Use decimal money arithmetic. Reconcile tax-inclusive invoice totals, order totals, discounts, refunds, actual debits, and the proposed reimbursement total. Follow an established or user-confirmed amount convention. When no convention is specified and a payment shows a discount, use the actual debit in the proposed total and explain the invoice difference. Record the reason for each difference supported by the evidence.

Describe add-ons using the invoice and order details. If the user confirms that an add-on is a delay-compensation product (延误赔) and should be included in airfare, group its invoices under airfare, update all totals and package names, and remove obsolete pending-confirmation text. The user-confirmed classification is sufficient for local packaging.

For incremental attachments, re-evaluate the outstanding items and answer with the updated checklist. Distinguish completed, exempt, and unresolved items. Exclude visibly unrelated dates/routes from the target contest. Avoid adding requirements merely because a document field looks unusual.

When the user is searching their statements, give observed payment dates first, then explicitly labeled search ranges and useful amounts/merchant names. Invoice dates are search clues rather than payment dates. Check supplied notices for fee deadlines and collection methods before estimating. If relying on ticket presale rules, verify the applicable rule and label the resulting window as an estimate. Search mail only within the user's authorized scope and report which folders/date ranges were actually checked.

## Assemble the requested package

Preparation of a local folder and ZIP can proceed once requested, including with documented remaining gaps. Apply the confirmed exemptions and classifications without asking for the same confirmation again.

1. Create a dedicated output folder beside the sources, normally `比赛名称报销-总额` with amounts to two decimal places. Follow a user-specified or existing layout when provided. Preserve source folders and original attachments.
2. For each contest in the package, verify the visible seal on its invitation or contest notice and include the sealed version. Include category folders with subtotals, existing formal invoices/tickets, matching orders and required payment evidence, and a concise Chinese expense summary. Use descriptive filenames with traveler, direction/date, route, and amount when supported by the source.
3. Keep each original invoice intact. Make one primary copy of each invoice. Retain provided alternate XML/OFD originals in clearly labeled subfolders when useful, with a note that the expense counts once. Avoid multiple visual copies of the same invoice in the submission view.
4. Use final orders and schedule changes to match invoices. Correct misleading route labels in output filenames using the ticket/order content. Keep ambiguous identities unassigned instead of inventing links.
5. Sum category amounts into the proposed reimbursement total and use that same total in the summary, root folder name, and ZIP name. Show invoice total and actual-payment total separately when they differ. A waived payment record leaves the supported invoice expense in the total.
6. Create a ZIP with one root folder and relative member paths. Verify archive integrity, file counts, ledger coverage, and byte-for-byte agreement with the selected originals and output folder. Keep rendering intermediates out of the delivery folder.
7. For revisions, inspect existing outputs and stop before overwriting user edits. Regenerate the ZIP from the revised folder and verify it. Retire a superseded agent-generated package only after its replacement is verified, preserving any user-authored changes and original source materials.

End with links to the folder and ZIP, the proposed total, material exceptions or unresolved evidence, and any consequential amount/classification choice. A locally verified package is ready for the user's submission step. Sending it to a recipient or submitting it to a finance system requires authorization for that external action.

## Privacy

Keep actual invoices, payment screenshots, travelers, identity numbers, account identifiers, bank details, purchaser tax identifiers, and personal file paths in the user's local task materials. This repository contains reusable instructions and synthetic examples. Installation or validation of this skill uses synthetic fixtures and isolated output directories.
