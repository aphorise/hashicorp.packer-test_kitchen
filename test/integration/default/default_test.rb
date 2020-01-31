# InSpec test for recipe nginx::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

# check that nginx is installed
describe package('nginx') do
  it { should be_installed }
end

# check http port 80 is active with nginx 
describe port('127.0.0.1', 80) do
  it { should_not be_listening }
end

#unless os.windows?
  # This is an example test, replace with your own test.
#  describe user('root'), :skip do
#    it { should exist }
#  end
#end
