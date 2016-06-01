class BenchmarkFilter 
   def self.around(controller)
     timer = Time.now
     Rails.logger.debug "---#{controller.controller_name} #{controller.action_name} begin"
     yield # 這裡讓出來執行Action動作
     elapsed_time = Time.now - timer
     Rails.logger.debug "---#{controller.controller_name} #{controller.action_name} finished in %0.2f" % elapsed_time
   end
   
   def self.before(controller)
       Rails.logger.debug "---#{controller.controller_name} #{controller.action_name}--before--#{controller.request.remote_ip}"
   end

   def self.after(controller)
       Rails.logger.debug "---#{controller.controller_name} #{controller.action_name}--after"
   end
end
