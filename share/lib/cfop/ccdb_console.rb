module CfOp
  module CcdbConsole
    class << self
      def build_command(yaml, conf_path)
        ccdb = yaml['properties']['ccdb']

        host = ccdb['address']
        port = ccdb['port']
        user = ccdb['roles'][0]['name']
        db_name = ccdb['databases'][0]['name']
        %W(mysql --defaults-extra-file=#{conf_path} -h #{host} -P #{port} -D #{db_name} -u #{user})
      end

      def ccdb_password(yaml)
        yaml['properties']['ccdb']['roles'][0]['password']
      end
    end
  end
end
