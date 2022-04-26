package com.wyn.crm.mapper;

import com.wyn.crm.entity.ClueRemark;
import com.wyn.crm.entity.ClueRemarkExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface ClueRemarkMapper {
    int countByExample(ClueRemarkExample example);

    int deleteByExample(ClueRemarkExample example);

    int deleteByPrimaryKey(String id);

    int insert(ClueRemark record);

    int insertSelective(ClueRemark record);

    List<ClueRemark> selectByExample(ClueRemarkExample example);

    ClueRemark selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") ClueRemark record, @Param("example") ClueRemarkExample example);

    int updateByExample(@Param("record") ClueRemark record, @Param("example") ClueRemarkExample example);

    int updateByPrimaryKeySelective(ClueRemark record);

    int updateByPrimaryKey(ClueRemark record);


    List<ClueRemark> getClueRemarkList(String id);

    int deleteClueRemarkByClueId(@Param("clueId") String clueId);
}