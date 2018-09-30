require "banks_api/transaction"

module BanksApi
  module Ynab
    class SaveTransactionConverter < SimpleDelegator
      attr_accessor :occurrence

      def initialize(transaction, **extra_params)
        super(transaction)
        @extra_params = extra_params
      end

      def convert
        YNAB::SaveTransaction.new(attributes.merge(extra_params))
      end

      def import_id_without_occurrence
        [
          "YNAB",
          amount_milliunits,
          date.iso8601
        ].join(":")
      end

      private

        attr_reader :extra_params

        def attributes
          {
            #account_id: nil,
            date: date,
            amount: amount_milliunits,
            #payee_id: nil,
            #payee_name: nil,
            #category_id: nil,
            memo: description,
            #cleared: false,
            #approved: false,
            #flag_color: nil,
            import_id: import_id
          }
        end

        def amount_milliunits
          (amount.amount * 1000).to_i
        end

        def import_id
          [
            import_id_without_occurrence,
            occurrence
          ].join(":")
        end
    end
  end
end
