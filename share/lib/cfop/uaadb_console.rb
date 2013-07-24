module CfOp
  module UaadbConsole
    class << self
      def build_command(yaml, conf_path)
        uaadb = yaml['properties']['uaadb']

        host = uaadb['address']
        port = uaadb['port']
        user = uaadb['roles'][0]['name']
        db_name = uaadb['databases'][0]['name']
        %W(mysql --defaults-extra-file=#{conf_path} -h #{host} -P #{port} -D #{db_name} -u #{user})
      end

      def uaadb_password(yaml)
        yaml['properties']['uaadb']['roles'][0]['password']
      end
    end
  end
end
