require "banks_api/ynab/save_transaction_converter"

module BanksApi
  module Ynab
    class BulkTransactions < YNAB::BulkTransactions
      def initialize(banks_api_transactions, account_id:)
        @banks_api_transactions = banks_api_transactions
        @account_id = account_id
        reset_occurrences
        @transactions = ynab_save_transactions
      end

      private

        attr_reader :banks_api_transactions, :account_id, :occurrences

        def ynab_save_transactions
          banks_api_transactions.map do |transaction|
            transaction_converter = SaveTransactionConverter.new(
              transaction,
              account_id: account_id
            )
            transaction_converter.occurrence = occurrence_for(transaction_converter)

            transaction_converter.convert
          end
        end

        def occurrence_for(transaction_converter)
          occurrences[transaction_converter.import_id_without_occurrence] += 1
        end

        def reset_occurrences
          @occurrences = Hash.new(0)
        end
    end
  end
end
