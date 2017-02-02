class CertificateAcquisition < ActiveRecord::Base
  belongs_to :user
  belongs_to :certification
end
