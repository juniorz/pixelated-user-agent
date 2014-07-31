module Smail
  class << self
    def mail_service
      @mail_service ||= MailService.new
    end
  end

  module Fake
    PERSONAS = [
                Persona.new(1, "Yago Macedo", nil, "sirineu@souza.org")
               ]

    def personas
      PERSONAS.map(&:ident)
    end

    def persona(i)
      PERSONAS.select { |x| x.ident.to_s == i}.first
    end

    def mails(query, page_number, window_size)
      with_timing do
        stats, mails = Smail.mail_service.mails(query, page_number, window_size)
        { stats: stats, mails: mails.to_a }
      end
    end

    def contacts(query, page_number, window_size)
      with_timing do
        contacts = Smail.mail_service.contacts(query, page_number, window_size)
        { contacts: contacts.to_a }
      end
    end

    def contact(ix)
      Smail.mail_service.contact(ix)
    end

    def delete_mails(query, page_number, window_size, mails_idents)
      idents = mails_idents.gsub(/[\[\]]/, '').split(',').collect {|x| x.to_i}
      Smail.mail_service.delete_mails(query, page_number, window_size, idents)
      []
    end

    def mail(i)
      Smail.mail_service.mail(i)
    end

    def send_mail(data)
      Smail.mail_service.send_mail(data)
    end

    def update_mail(data)
      Smail.mail_service.update_mail(data)
    end

    def delete_mail(i)
      Smail.mail_service.delete_mail(i)
    end

    def draft_reply_for(i)
      Smail.mail_service.draft_reply_for(i)
    end

    def tags(i)
      Smail.mail_service.mail(i).tag_names
    end

    def create_tag(tag_json)
      Smail.mail_service.create_tag tag_json
    end

    def all_tags(q)
      Smail.mail_service.tags(q)
    end

    def settags(i, body)
      m = Smail.mail_service.mail(i)
      m.tag_names = body["newtags"]
      m.tag_names
    end

    def starmail(i, val)
      m = Smail.mail_service.mail(i)
      m.starred = val if m
      ""
    end

    def repliedmail(i, val)
      m = Smail.mail_service.mail(i)
      m.replied = val if m
      ""
    end

    def readmail(i, val)
      m = Smail.mail_service.mail(i)
      m.read = val if m
      ""
    end

    def readmails(mail_idents, val)
      idents = mail_idents.gsub(/[\[\]]/, '').split(',').collect {|x| x.to_i}
      Smail.mail_service.each { |k,v| readmail(k.ident, val) if idents.include?(k.ident) }
      []
    end

    def control_create_mail
      Smail.mail_service.create
      ""
    end

    def control_delete_mails
      Smail.mail_service.clean
      ""
    end

    def control_mailset_load(name)
      with_timing do
        {
          stats: Smail.mail_service.load_mailset(name),
          loaded: name
        }
      end
    end

    def stats
      Smail.mail_service.stats_report
    end

    def with_timing
      before = Time.now
      result = yield
      after = Time.now
      res = case result
            when Hash
              result.dup
            when nil
              {}
            else
              { result: result }
            end
      res[:timing] = { duration: after - before }
      res
    end
  end
end
