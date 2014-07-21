from socket import *
import sys


class DataAnalyze:
	'''class DataAnalyze for Git'''
	def __init__(self , host='localhost' , port=80):
		'''constructor'''
		self.host = host
		self.port = port
		self.so = socket(family = AF_INET , type = SOCK_STREAM)
		pass
	def start(self):
		'''start server'''
		try:
			self.so.connect((self.host , self.port))
		except Exception as Reason:
			print('socket connection error : %s'%(Reason))
			return
			pass
		while True:
			try:
				line = sys.stdin.readline()
				print(line)
				self.so.send(line)
				pass
			except Exception as Reason:
				print('exception:%s'%(Reason))
				pass
		pass
	pass

da = DataAnalyze(port=7777)
da.start()
