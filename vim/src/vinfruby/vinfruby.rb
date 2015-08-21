require 'drb'

module VInfRuby
    class Server
        def initialize
        end

        def evaluate(line, line_no)
            IRB.conf[:MAIN_CONTEXT].evaluate(line, line_no)
        end
    end

    def self.init( port = 33668 )
        @@server = Server.new
        DRb.start_service("druby://localhost:#{port}", @@server)
    end
end

VInfRuby.init

