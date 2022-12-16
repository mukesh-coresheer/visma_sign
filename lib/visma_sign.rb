# frozen_string_literal: true

require_relative "visma_sign/version"

module VismaSign
  class Error < StandardError; end

  class Api
    attr_accessor :token, :base_url
    REQUIRED_ENV = %w[VISMAUSERNAME VISMAPASSWORD GRANTTYPE VISMACLIENTID VISMASCOPE].freeze

    def initialize
      check_for_env
      @base_url = "https://vismasign.frakt.io"
      login
    end

    def login
      response = JSON.parse(
        request(
          "/api/v1/auth/token",
          login_payload,
          headers(auth_token: false),
          :post
        ).body
      )

      @token = response["access_token"]
      response
    end

    def create_document(payload)
      request(
        "/api/v1/document/", payload.to_json,
        headers, :post
      )
    end

    def add_file(uuid, file)
      JSON.parse(
        request("/api/v1/document/#{uuid}/files", file, headers(content_type: "application/pdf"), :post).body
      )
    end

    def create_invitation(uuid:, email:, full_name:, number: nil, language: "fi")
      payload = invitaion_payload(email: email, full_name: full_name, number: number, language: language)

      JSON.parse(
        request(
          "/api/v1/document/#{uuid}/invitations", payload.to_json, headers, :post
        ).body
      )
    end

    def invitation(uuid)
      JSON.parse(
        request(
          "/api/v1/invitation/#{uuid}", headers, :get
        ).body
      )
    end

    def search_document(payload: {})
      url = URI("/api/v1/document/")
      url.query = payload.to_query if payload.present?

      JSON.parse(
        request(url, {}, headers).body
      )
    end

    def delete_document(uuid)
      request("/api/v1/document/#{uuid}", {}, headers, :delete)
    end

    private

    def login_payload
      {
        "username" => ENV["VISMAUSERNAME"],
        "password" => ENV["VISMAPASSWORD"],
        "grant_type" => ENV["GRANTTYPE"],
        "client_id" => ENV["VISMACLIENTID"],
        "scope" => ENV["VISMASCOPE"]
      }
    end

    def invitaion_payload(email:, full_name:, number: nil, language: "fi")
      [
        {
          email: ENV["TEST_EMAIL"] || email,
          name: full_name,
          messages: {
            send_invitation_email: true,
            send_invitation_sms: false,
            separate_invite_parts: false,
            attachment_allowed: false,
            send_invitee_all_collected_email: true
          },
          language: language,
          order: { require_before_sending_next_invitations: false },
          sign_as_organization: false,
          signature_type: "strong",
          show_identifier_in_signature: false,
          inviter: {
            language: language,
            organization_only: true
          },
          document_read: false,
          attachment_read: false
        }.tap do |a|
          a[:sms] = number if number.present?
        end
      ]
    end

    def headers(content_type: "application/json", auth_token: true)
      {
        "Content-Type" => content_type
      }.tap do |t|
        t["Authorization"] = "Bearer #{token}" if auth_token
      end
    end

    def request(url, payload, header, method = :get)
      url = URI("#{base_url}#{url}")
      if url.query.present?
        url.query = "#{url.query}&#{{ as_organization: ENV["AS_ORGANIZATION"] }.to_query}"
      elsif ENV["AS_ORGANIZATION"].present?
        url.query = { as_organization: ENV["AS_ORGANIZATION"] }.to_query
      end

      RestClient::Request.execute(
        method: method,
        url: url.to_s,
        payload: payload,
        headers: header
      )
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end

    def check_for_env
      missing_env = []
      REQUIRED_ENV.each do |env|
        missing_env << env unless ENV.key?(env)
      end

      raise missing_env.join(',') if missing_env.present?
    end
  end
end
