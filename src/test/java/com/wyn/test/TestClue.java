package com.wyn.test;

import com.github.pagehelper.Page;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.wyn.crm.entity.Clue;
import com.wyn.crm.entity.Customer;
import com.wyn.crm.mapper.ClueMapper;
import com.wyn.crm.mapper.CustomerMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import sun.misc.Cleaner;

import java.util.List;

/**
 * @author wei-ya-nan
 * @version 1.0
 * @date 2022/4/22
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml","classpath:applicationContext-datasource" +
        ".xml"})
public class TestClue {
    @Autowired
    private ClueMapper clueMapper;

    @Autowired
    private CustomerMapper customerMapper;

    @Test
    public void test01(){
//        Clue clue = new Clue();
//        clue.setCompany("大唐造有限公司");
        Page page = PageHelper.startPage(1, 5,false);
        List<Clue> list = clueMapper.getClueConditionPageByEntity(new Clue());
        PageInfo<Clue> pageInfo = new PageInfo<Clue>(list,5);
//        System.out.println(pageInfo);
        System.out.println(pageInfo.getList().get(0).getCompany());

    }
    @Test
    public void test02(){
        PageHelper.startPage(1,5);
        List<Customer> customers = customerMapper.queryPage(null, null, null, null);
        PageInfo<Customer> pageInfo = new PageInfo<Customer>(customers, 5);
        System.out.println(pageInfo);
    }
}
