require "banks_api/ynab/bulk_transactions_converter"

module BanksApi
  module Ynab
    class Sync
      def self.run(*args)
        new(*args).run
      end

      def initialize(ynab_budget_id:, ynab_account_id:, bank_name:, credentials:, bank_account_id:, date_from:, date_to:)
        @ynab_budget_id = ynab_budget_id
        @ynab_account_id = ynab_account_id
        @bank_name = bank_name
        @credentials = credentials
        @bank_account_id = bank_account_id
        @date_from = date_from
        @date_to = date_to
      end

      def run
        ynab_api.transactions.bulk_create_transactions(ynab_budget_id, bulk_transactions)
      end

      private

        attr_reader :ynab_budget_id, :ynab_account_id, :bank_name, :credentials, :bank_account_id, :date_from, :date_to

        def bulk_transactions
          BanksApi::Ynab::BulkTransactions.new(banks_api_transactions, account_id: ynab_account_id)
        end

        def banks_api_transactions
          bank_account.transactions(from: date_from, to: date_to)
        end

        def bank_account
          @_bank_account ||= user_account.account(bank_account_id)
        end

        def user_account
          @_user_account ||= BanksApi::UserAccount.new(bank_name, credentials)
        end

        def ynab_api
          @_ynab_api ||= YNAB::API.new(ENV["YNAB_API_TOKEN"])
        end
    end
  end
end
